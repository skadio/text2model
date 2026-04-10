include "globals.mzn";

% Max flow from node 0 (source) to node 7 (sink) on a directed network with capacities.

int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

% Capacity matrix cap[i,j] (0 means no arc).
array[V, V] of int: cap =
[
|  0,  6, 16,  5,  6, 11,  6,  4 |
|  0,  0,  8, 10,  6,  3,  6, 14 |
|  0,  6,  0, 20,  7, 16, 13, 14 |
|  0, 11, 19,  0, 18,  5,  0,  8 |
|  0,  1, 14, 18,  0, 12,  4,  7 |
|  0, 16,  3, 20,  7,  0, 15,  6 |
|  0, 11,  4, 19,  7,  6,  0, 17 |
|  0,  0,  0,  0,  0,  0,  0,  0 |
];

% Upper bound on any single flow variable and on total flow
int: U = sum(i in V, j in V)(cap[i,j]);

% Flow variables on every ordered pair (i,j)
array[V, V] of var 0..U: f;

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% No self-loops
constraint forall(i in V) ( f[i,i] = 0 );

% Flow conservation at intermediate nodes (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

% Net flow value (out of source minus into source)
var 0..U: F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Equivalent net flow into sink (for consistency)
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output [
  "Max flow = ", show(F), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j == 0 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n" | i in V ])
];