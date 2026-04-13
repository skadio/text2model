% Max flow from source (0) to sink (7) on a directed graph with 8 nodes.
% All capacities are embedded below.

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
% to:   0  1  2  3  4  5  6  7
[|      0, 3, 7, 2,18,18,14,10  % from 0
 |      1, 0,10,16,14, 0, 6,10  % from 1
 |      4, 0, 0, 7, 2, 2, 6,10  % from 2
 |      2, 3, 7, 0,20, 8, 6,10  % from 3
 |      1,20, 4, 8, 0,13, 8, 1  % from 4
 |     16, 9,17,17,11, 0, 7, 8  % from 5
 |      3, 7,14, 1,20, 5, 0,13  % from 6
 |      3, 6, 5, 1,14,20, 9, 0  % from 7
|];

int: U = max([cap[i,j] | i in V, j in V]);
array[V, V] of var 0..U: f;

% Capacity constraints (also force f=0 when cap=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define total flow value as net outflow from source (equivalently inflow to sink)
var 0..sum(j in V)(cap[s,j]): F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize F;

output [
  "Optimal max flow (thousand units) = ", show(F), "\n"
];