% Max flow from source (0) to sink (7) with given directed capacities.
include "globals.mzn";

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

% Capacity matrix c[u,v] (tons/day). 0 means no direct road.
array[V, V] of int: c =
[| 0,11, 1, 6, 4, 5, 7, 1
 | 3, 0,15,15,16, 9,14,12
 |19, 9, 0, 5, 9,11,16, 3
 |15, 1,14, 0, 0, 4, 1,15
 | 8,16, 7, 3, 0,16,10,11
 | 7, 8, 1,11,19, 0, 3, 3
 | 2,19, 2, 6,12,20, 0, 6
 |15,17, 4, 7, 8, 2,16, 0 |];

% Decision variables: flow on each directed arc
array[V, V] of var 0..max(c): f;

% Capacity constraints
constraint forall(u in V, v in V) (
  f[u,v] <= c[u,v]
);

% No self-flow (optional, but tightens)
constraint forall(u in V) ( f[u,u] = 0 );

% Flow conservation on intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

% Objective: maximize net flow into sink (equivalently out of source)
var 0..sum(u in V)(c[s,u]): maxFlow;
constraint maxFlow = sum(u in V)(f[u,t]) - sum(w in V)(f[t,w]);

solve maximize maxFlow;

output [
  "Maximum flow (tons/day) = ", show(maxFlow), "\n",
  "Flow matrix f[u,v]:\n", show(f), "\n"
];