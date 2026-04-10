include "globals.mzn";

% Max-flow from node 0 (source) to node 6 (sink) on a directed graph with capacities.
int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

% Capacity matrix cap[i,j] (Tbps); 0 means no direct link.
array[V, V] of int: cap =
  array2d(V, V,
  [
    % j=0  1  2  3  4  5  6
      0, 18,  2, 10, 17,  0, 12,   % i=0
     14,  0,  3,  1, 19, 18,  2,   % i=1
     17,  5,  0, 15, 15, 19,  0,   % i=2
     14, 17,  0,  0, 19,  9, 16,   % i=3
      2, 13, 15, 12,  0, 20,  5,   % i=4
      9, 16,  4, 15, 15,  0, 11,   % i=5
      8, 10, 19, 19, 17, 16,  0    % i=6
  ]);

% Decision variables: flow on each arc (i->j)
int: U = max([cap[i,j] | i in V, j in V]);
array[V, V] of var 0..U: f;

% Capacity constraints and forbid flow where no arc exists
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% No self-loops flow
constraint forall(i in V) ( f[i,i] = 0 );

% Flow conservation on intermediate nodes
constraint forall(k in V where k != s /\ k != t) (
  sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
);

% Define total flow value
var 0..sum(j in V)(cap[s,j]): value;
constraint value = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint value = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize value;

output [
  "Maximum flow (Tbps) = ", show(value), "\n",
  "Flow matrix f[i,j] (Tbps):\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n" | i in V ])
];