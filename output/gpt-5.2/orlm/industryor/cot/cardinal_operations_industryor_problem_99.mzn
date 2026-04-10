% Parameters (with values embedded)
int: N = 5;
set of int: Nodes = 1..N;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

% Directed bandwidth matrix bw[i,j]; 0 means no direct link
array[Nodes, Nodes] of int: bw =
[| 0, 90, 85,  0, 65
 | 95,  0, 70, 65, 34
 | 60,  0,  0, 88, 80
 | 67, 30, 25,  0, 84
 |  0, 51,  0, 56,  0
 |];

int: maxBW = max([bw[i,j] | i in Nodes, j in Nodes]);

% Variables
array[Nodes, Nodes] of var 0..1: x;          % x[i,j]=1 if arc i->j is on the path
array[Nodes] of var 0..1: y;                 % y[i]=1 if node i is used on the path
array[Nodes] of var 1..N: pos;               % topological order to forbid loops
var 0..maxBW: Z;                             % path bandwidth (minimum arc bandwidth)

% Constraints
% Only allow selecting existing arcs (bandwidth > 0) and no self-loops
constraint forall(i,j in Nodes) (
  x[i,j] = 0 \/ (i != j /\ bw[i,j] > 0)
);
constraint forall(i in Nodes) (x[i,i] = 0);

% Flow conservation for a single directed simple path from A to E
constraint forall(i in Nodes) (
  sum(j in Nodes)(x[i,j]) <= 1 /\   % at most one outgoing
  sum(j in Nodes)(x[j,i]) <= 1      % at most one incoming
);

constraint sum(j in Nodes)(x[A,j]) = 1;
constraint sum(j in Nodes)(x[j,A]) = 0;

constraint sum(j in Nodes)(x[j,E]) = 1;
constraint sum(j in Nodes)(x[E,j]) = 0;

constraint forall(i in Nodes where i != A /\ i != E) (
  sum(j in Nodes)(x[i,j]) = sum(j in Nodes)(x[j,i])   % 0 if unused, 1 if on path
);

% Node usage indicator
constraint y[A] = 1 /\ y[E] = 1;
constraint forall(i in Nodes) (
  y[i] >= sum(j in Nodes)(x[i,j]) /\
  y[i] >= sum(j in Nodes)(x[j,i]) /\
  y[i] <= sum(j in Nodes)(x[i,j]) + sum(j in Nodes)(x[j,i]) + (if i == A \/ i == E then 1 else 0 endif)
);

% Must pass through service node C
constraint y[C] = 1;

% No loops: enforce increasing order along selected arcs
constraint pos[A] = 1;
constraint forall(i,j in Nodes where i != j) (
  x[i,j] = 1 -> pos[j] >= pos[i] + 1
);

% Define link bandwidth Z as the minimum bandwidth along chosen arcs
constraint forall(i,j in Nodes) (
  x[i,j] = 1 -> Z <= bw[i,j]
);
constraint exists(i,j in Nodes) (x[i,j] = 1 /\ Z = bw[i,j]); % Z equals at least one selected arc bandwidth

% Objective
solve maximize Z;

output [
  "Maximized path bandwidth Z = ", show(Z), "\n",
  "Selected arcs (i->j):\n"
] ++
[
  if fix(x[i,j]) == 1 then
    "  " ++ (["A","B","C","D","E"][i]) ++ " -> " ++ (["A","B","C","D","E"][j]) ++
    " (bw=" ++ show(bw[i,j]) ++ ")\n"
  else "" endif
  | i in Nodes, j in Nodes
];