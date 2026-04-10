include "globals.mzn";

% Max-flow from source 0 to sink 8 on a directed graph with capacities.
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix cap[u,v] (0 means no arc).
array[V, V] of int: cap =
array2d(V, V, [
  % v=0  1   2   3   4   5   6   7   8
     0, 14, 20,  7,  9,  1,  4,  8, 19,  % u=0
     3,  0, 15, 12, 17,  0, 15,  3,  3,  % u=1
    11,  8,  0,  1, 19, 16,  5,  1,  2,  % u=2
    13, 13,  2,  0, 16, 20, 16, 17,  3,  % u=3
     6, 15,  7,  3,  0, 18,  1,  3,  9,  % u=4
    15, 20,  8,  4,  6,  0,  3,  1,  4,  % u=5
     5, 15, 19,  4, 15, 12,  0,  3,  8,  % u=6
     7, 14, 13, 12,  9, 10,  3,  0,  4,  % u=7
     3, 12,  6,  6,  1, 11,  6,  1,  0   % u=8
]);

% Flow variables on every ordered pair; forced to 0 when cap=0.
array[V, V] of var 0..max(cap): f;

constraint forall(u,v in V) (
  f[u,v] <= cap[u,v]
);

% Flow conservation for all intermediate nodes (not s or t):
% sum_in = sum_out
constraint forall(i in V where i != s /\ i != t) (
  sum(u in V)(f[u,i]) = sum(v in V)(f[i,v])
);

% Maximize total flow out of source (equivalently into sink by conservation).
var 0..sum(v in V)(cap[s,v]): totalFlow = sum(v in V)(f[s,v]);

solve maximize totalFlow;

output [
  "Maximum throughput (packets/hour) = ", show(totalFlow), "\n",
  "Flow matrix f[u,v]:\n",
  concat([ concat([ if v==0 then "" else " " endif ++ show(f[u,v]) | v in V ]) ++ "\n" | u in V ])
];