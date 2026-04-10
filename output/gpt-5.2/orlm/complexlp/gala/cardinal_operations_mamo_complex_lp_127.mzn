include "globals.mzn";

% Max flow from source 0 to sink 8 on a directed graph with capacities.
% Data is embedded as requested.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix (cap[i,j] = max flow on arc i->j), in thousands of units.
array[V, V] of int: cap =
array2d(V, V,
[
  % to:  0, 1, 2, 3, 4, 5, 6, 7, 8
        0,13,19,17, 7, 7,11, 7, 7,  % from 0
        9, 0,19,20,10,19,20,19, 3,  % from 1
        0,16, 0, 0,10, 2,14, 9, 9,  % from 2
        6, 0, 5, 0, 7,18,15,20, 7,  % from 3
       18,19,12, 0, 0,16,20,10, 4,  % from 4
        3, 4, 8, 9,20, 0, 7, 8, 1,  % from 5
        3,14,14,16, 1,12, 0,10,10,  % from 6
        9,20,19, 4, 9,16, 1, 0, 6,  % from 7
        0,15,14,18,18,11,18, 0, 0   % from 8
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Decision variables: flow on each arc
array[V, V] of var 0..maxCap: f;

% Respect capacities; force no-flow where there is no arc (cap=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize total flow leaving source (equivalently entering sink)
var 0..(N*maxCap): F;
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize F;

output [
  "Maximum flow (thousands of units) = ", show(F), "\n\n",
  "Flow matrix f[i,j] (thousands), rows=from i, cols=to j:\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n" | i in V ])
];