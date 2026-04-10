include "globals.mzn";

% Max flow from source 0 to sink 8 on a directed graph with given capacities.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix cap[i,j] (0 means no arc)
array[V, V] of int: cap =
array2d(V, V, [
  % to:  0  1  2  3  4  5  6  7  8   from:
          0, 7, 4,17, 4,18,17, 5,14, % 0
          2, 0,11,10, 1,19, 6,16,13, % 1
          8,15, 0, 5, 1, 5,11,17,18, % 2
          2, 5, 0, 0, 6,17, 1,16,14, % 3 (no 3->2 given; set to 0; 3->3 is 0)
         15, 6,20,15, 0, 7,13, 6,19, % 4
         15, 2, 8, 2, 3, 0, 2, 9, 2, % 5
         10,12,11,10,19, 9, 0,17, 1, % 6
          0,20,15,19,20,18,14, 0, 8, % 7
         16,13, 3, 3,20,19, 2, 7, 0  % 8
]);

% Flow variables on all directed pairs (including pairs with cap=0, forced to 0)
array[V, V] of var 0..20: f;

% Capacity constraints and zeroing non-arcs (and self loops)
constraint forall(i, j in V) (
  (i = j \/ cap[i,j] = 0) -> f[i,j] = 0
);
constraint forall(i, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation on intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize total outflow from s (equivalently inflow to t)
var 0..1000: maxflow = sum(j in V)(f[s,j]);
constraint maxflow = sum(i in V)(f[i,t]);

solve maximize maxflow;

output [
  "Maximum flow from ", show(s), " to ", show(t), " = ", show(maxflow), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n" | i in V ])
];