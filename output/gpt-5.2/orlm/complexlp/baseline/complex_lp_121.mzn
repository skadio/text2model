% Maximum flow in a directed network (8 nodes: 0..7)
include "globals.mzn";

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

% Capacity matrix cap[i,j] (0 means no arc)
array[V,V] of int: cap =
[
|  0,  6, 16,  5,  6, 11,  6,  4
|  0,  0,  8, 10,  6,  3,  6, 14
|  0,  6,  0, 20,  7, 16, 13, 14
|  0, 11, 19,  0, 18,  5,  0,  8
|  0,  1, 14, 18,  0, 12,  4,  7
|  0, 16,  3, 20,  7,  0, 15,  6
|  0, 11,  4, 19,  7,  6,  0, 17
|  0,  5,  8, 17,  2,  5,  4,  0
];

% Flow variables on all pairs (will be forced to 0 if no capacity)
array[V,V] of var 0..max(cap): f;

% Capacity constraints + no self-flow
constraint forall(i in V, j in V) (
  (i = j -> f[i,j] = 0) /\
  (cap[i,j] = 0 -> f[i,j] = 0) /\
  (cap[i,j] > 0 -> f[i,j] <= cap[i,j])
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Maximize total outflow from source (equals inflow to sink by conservation)
var 0..sum(j in V)(cap[s,j]): total_flow = sum(j in V)(f[s,j]);

solve maximize total_flow;

output [
  "Maximum flow (TB/h) from ", show(s), " to ", show(t), " = ", show(total_flow), "\n"
];