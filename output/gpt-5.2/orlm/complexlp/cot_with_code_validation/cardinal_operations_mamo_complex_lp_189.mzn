% Maximum flow on a directed graph (embedded data)

% Parameters
int: N = 4;
set of int: V = 1..N;

array[V, V] of int: cap = array2d(V, V, [
  0, 8, 7, 0,
  0, 0, 2, 4,
  0, 0, 0, 12,
  0, 0, 0, 0
]);

int: s = 1;
int: t = 4;

int: UB = sum(i in V, j in V where cap[i,j] > 0)(cap[i,j]);

% Variables
array[V, V] of var 0..UB: f;
var 0..UB: maxflow;

% Constraints
constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);
constraint forall(i in V, j in V where cap[i,j] = 0) (f[i,j] = 0);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define max flow as net outflow from source
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Objective
solve maximize maxflow;

% Optional output
output [
  "maxflow = ", show(maxflow), "\n",
  "flow matrix f:\n",
  concat([ concat([ show(f[i,j]) ++ if j == N then "\n" else " " endif | j in V ]) | i in V ])
];