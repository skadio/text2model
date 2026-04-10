% Maximize the bottleneck bandwidth of a simple path A -> E that must pass C.

%-----------------------------
% Data
%-----------------------------
int: N = 5;
set of int: V = 1..N;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[V, V] of int: bw =
[| 0, 90, 85,  0, 65
 | 95,  0, 70, 65, 34
 | 60,  0,  0, 88, 80
 | 67, 30, 25,  0, 84
 |  0, 51,  0, 56,  0 |];

int: BIGM = 1000;

%-----------------------------
% Decision variables
%-----------------------------
array[V, V] of var 0..1: x;   % x[i,j]=1 iff arc i->j is used
var 0..100: bottleneck;       % minimum bandwidth along the chosen arcs

%-----------------------------
% Constraints
%-----------------------------
% Disallow self loops and non-edges (bw=0)
constraint forall(i,j in V where i = j \/ bw[i,j] = 0) (
  x[i,j] = 0
);

% Path degree constraints: source A, sink E
constraint sum(j in V)(x[A,j]) = 1;
constraint sum(i in V)(x[i,A]) = 0;

constraint sum(i in V)(x[i,E]) = 1;
constraint sum(j in V)(x[E,j]) = 0;

% Flow conservation for intermediate nodes
constraint forall(v in V where v != A /\ v != E) (
  sum(i in V)(x[i,v]) = sum(j in V)(x[v,j])
);

% Must pass through C (exactly one in and one out)
constraint sum(i in V)(x[i,C]) = 1;
constraint sum(j in V)(x[C,j]) = 1;

% No repeated nodes: at most one incoming and at most one outgoing per node
constraint forall(v in V) ( sum(i in V)(x[i,v]) <= 1 );
constraint forall(v in V) ( sum(j in V)(x[v,j]) <= 1 );

% Bottleneck definition: for each selected arc, bottleneck <= its bandwidth
constraint forall(i,j in V) (
  bottleneck <= bw[i,j] + (1 - x[i,j]) * BIGM
);

%-----------------------------
% Objective
%-----------------------------
solve maximize bottleneck;

%-----------------------------
% Output
%-----------------------------
output [
  "bottleneck=", show(bottleneck), "\n",
  "arcs:\n"
] ++
[
  if fix(x[i,j]) = 1 then
    show(i) ++ " -> " ++ show(j) ++ " (bw=" ++ show(bw[i,j]) ++ ")\n"
  else "" endif
  | i,j in V
];