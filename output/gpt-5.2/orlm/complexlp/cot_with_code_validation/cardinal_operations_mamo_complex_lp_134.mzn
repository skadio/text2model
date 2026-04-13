% Maximum flow in a directed network (Aquaville water distribution)

% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V, [
  0,  2,  8, 17, 16, 20, 15, 12,  9,
  4,  0, 11,  7,  3, 19, 10, 19,  8,
 14,  7,  0,  7, 13, 19, 18, 20,  5,
 17, 17,  7,  0, 11,  7, 17,  0, 10,
 20, 10,  2, 18,  0, 15,  8,  6, 18,
  4,  9, 12,  1, 17,  0,  0, 13, 18,
 12, 15, 12, 19, 18, 19,  0,  6, 17,
 14,  1, 17, 20, 11, 20,  6,  0,  4,
 19,  3, 19, 12,  8, 18, 17, 13,  0
]);

int: U = sum(j in V)(cap[s, j]); % valid upper bound on max flow

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Capacity constraints
constraint forall(i in V, j in V) (f[i, j] <= cap[i, j]);

% No self-flow
constraint forall(i in V) (f[i, i] = 0);

% Flow conservation (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v, j]) = sum(i in V)(f[i, v])
);

% Define objective value as net outflow from source (equivalently inflow to sink)
constraint maxflow = sum(j in V)(f[s, j]) - sum(i in V)(f[i, s]);
constraint maxflow = sum(i in V)(f[i, t]) - sum(j in V)(f[t, j]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];