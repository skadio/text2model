include "globals.mzn";

% Max-flow from source (0) to sink (6) on a directed capacitated network.

int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

% Capacity matrix c[u,v] (0 means no arc).
array[V, V] of int: c =
  [|  0, 20, 19, 18,  0, 11,  2
   | 18,  0, 15, 10,  0,  9,  0
   | 18,  4,  0, 11, 15,  0, 13
   | 17,  3, 15,  0,  2,  4,  4
   |  2, 11, 17, 17,  0,  2, 17
   | 12,  4, 16, 13,  5,  0,  3
   |  7,  9, 17, 18, 16,  8,  0 |];

% Decision variables: flow on each directed arc.
array[V, V] of var 0..20: f; % 20 is a safe upper bound (max capacity in data)

% Capacity constraints + force zero where no arc
constraint forall(u in V, v in V) (
  f[u,v] <= c[u,v] /\
  (c[u,v] = 0 -> f[u,v] = 0)
);

% Flow conservation at intermediate nodes (not s or t)
constraint forall(v in V where v != s /\ v != t) (
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

% Total flow value
var 0..200: F;
constraint F = sum(v in V)(f[s,v]) - sum(u in V)(f[u,s]);
constraint F = sum(u in V)(f[u,t]) - sum(v in V)(f[t,v]);

solve maximize F;

output [
  "Max flow (thousand kg/day) = ", show(F), "\n",
  "Flow matrix f[u,v]:\n",
  concat([ concat([ if v = 0 then "" else " " endif ++ show(f[u,v]) | v in V ]) ++ "\n" | u in V ])
];