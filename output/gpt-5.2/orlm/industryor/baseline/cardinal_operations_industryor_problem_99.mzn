% Maximize bottleneck bandwidth on a simple path from A to E that must pass through C.

set of int: N = 1..5;
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[N, N] of int: bw = array2d(N, N, [
%   A   B   C   D   E
    0, 90, 85,  0, 65,   % A
   95,  0, 70, 65, 34,   % B
   60,  0,  0, 88, 80,   % C
   67, 30, 25,  0, 84,   % D
    0, 51,  0, 56,  0    % E
]);

array[N, N] of var bool: x; % x[i,j]=1 if arc i->j is used in the path

% No self loops and only allow existing links (bandwidth > 0)
constraint forall(i,j in N) (
  (i = j) -> not x[i,j]
);
constraint forall(i,j in N) (
  x[i,j] -> bw[i,j] > 0
);

% Flow conservation to form a single directed simple path from A to E
constraint sum(j in N)(bool2int(x[A,j])) = 1;
constraint sum(i in N)(bool2int(x[i,A])) = 0;

constraint sum(i in N)(bool2int(x[i,E])) = 1;
constraint sum(j in N)(bool2int(x[E,j])) = 0;

constraint forall(v in N where v != A /\ v != E) (
  sum(i in N)(bool2int(x[i,v])) = sum(j in N)(bool2int(x[v,j]))
);

% Force that the path passes through service node C (i.e., is used)
constraint sum(i in N)(bool2int(x[i,C])) = 1;
constraint sum(j in N)(bool2int(x[C,j])) = 1;

% No loops / simple path: each node used at most once (in-degree and out-degree <= 1)
constraint forall(v in N) (
  sum(i in N)(bool2int(x[i,v])) <= 1 /\
  sum(j in N)(bool2int(x[v,j])) <= 1
);

% MTZ subtour elimination / ordering to prevent cycles
array[N] of var 0..card(N): ord;
constraint ord[A] = 1;
constraint ord[E] >= 2;
constraint forall(v in N where v != A)(
  ord[v] >= 0
);
constraint forall(i,j in N where i != j) (
  x[i,j] -> ord[j] >= ord[i] + 1
);

% Bottleneck bandwidth = minimum bandwidth over used arcs
var 0..100: bottleneck;
constraint forall(i,j in N) (
  x[i,j] -> bottleneck <= bw[i,j]
);
% Also ensure bottleneck is tight (equals min over chosen arcs)
constraint exists(i,j in N) ( x[i,j] /\ bottleneck = bw[i,j] );

solve maximize bottleneck;

output [
  "Maximum bottleneck bandwidth = ", show(bottleneck), "\n",
  "Chosen directed link (path):\n",
  concat([ if fix(x[i,j]) then
             "  " ++ show(i) ++ " -> " ++ show(j) ++ "  (bw=" ++ show(bw[i,j]) ++ ")\n"
           else "" endif
           | i,j in N ])
]
++
[
  "Node mapping: 1=A, 2=B, 3=C, 4=D, 5=E\n"
];