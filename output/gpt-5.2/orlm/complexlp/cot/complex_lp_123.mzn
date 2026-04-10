% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
% rows = from-node, cols = to-node
[| 0,  6, 16, 12, 16,  3,  9,  3, 13  % from 0
 | 2,  0,  0, 20, 13,  7, 20, 11, 13  % from 1
 | 4, 15,  0, 14, 13,  5, 12, 14, 16  % from 2
 | 1,  0,  2,  0,  8,  7, 11, 14, 16  % from 3
 | 4, 19,  7, 14,  0,  1, 20, 14, 16  % from 4
 | 0,  0, 14,  4, 17,  0,  2, 20,  9  % from 5
 |12, 19,  3,  3,  0,  0,  0, 13,  3  % from 6
 | 8, 19, 16,  4,  6, 13,  9,  0, 15  % from 7
 |11,  6,  0,  6, 10,  9,  3,  1,  0  % from 8
 |];

int: totalCap = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..totalCap: f;   % flow on each directed arc
var 0..totalCap: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective value as net outflow from source (and inflow to sink)
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;