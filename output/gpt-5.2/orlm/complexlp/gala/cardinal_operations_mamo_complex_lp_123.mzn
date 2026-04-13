include "globals.mzn";

% Max-flow from source s=0 to sink t=8 on a directed graph with capacities cap[i,j].
int: n = 9;
set of int: V = 0..n-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[| 0,  6, 16, 12, 16,  3,  9,  3, 13
 | 2,  0,  0, 20, 13,  7, 20, 11, 13
 | 4, 15,  0, 14, 13,  5, 12, 14, 16
 | 1,  0,  2,  0,  8,  7, 11, 14, 16
 | 4, 19,  7, 14,  0,  1, 20, 14, 16
 | 0,  0, 14,  4, 17,  0,  2, 20,  9
 |12, 19,  3,  3,  0,  0,  0, 13,  3
 | 8, 19, 16,  4,  6, 13,  9,  0, 15
 |11,  6,  0,  6, 10,  9,  3,  1,  0 |];

int: U = sum(i in V, j in V)(cap[i,j]); % safe upper bound on total flow

array[V, V] of var 0..U: f;

% Capacity constraints (and force 0 flow where no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define objective: net outflow from source = net inflow to sink
var 0..U: maxFlow;
constraint maxFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint maxFlow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxFlow;

output [
  "Max flow from ", show(s), " to ", show(t), " = ", show(maxFlow), "\n"
];