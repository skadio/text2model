% Maximum flow in a directed capacitated network

% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap = array2d(V, V,
[
  0, 19,  5,  7,  0, 17, 19,  9,
  6,  0, 15, 15, 16,  8,  5,  0,
  5,  6,  0,  3, 10,  7,  6,  3,
  8,  2,  6,  0,  5, 17,  0,  1,
 17,  4, 10, 10,  0,  6, 15, 14,
 11, 11,  9,  7,  7,  0, 16, 19,
 13, 19, 14, 14, 16,  1,  0, 16,
  0, 14,  0, 17,  1,  7,  9,  0
]);

% Upper bound on max flow (sum of capacities out of source)
int: UB = sum(j in V)(cap[s,j]);

% Variables
array[V, V] of var 0..UB: f;
var 0..UB: maxflow;

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (exclude source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define maxflow as net outflow from source and net inflow to sink
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = \(maxflow)\n"];