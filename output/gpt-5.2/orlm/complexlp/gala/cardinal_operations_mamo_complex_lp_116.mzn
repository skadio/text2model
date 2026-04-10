% Maximum flow from node 0 (source) to node 8 (sink) on a directed graph.
% Data is embedded directly as requested.

include "globals.mzn";

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacities c[i,j] (TB/hour). 0 means no arc.
array[V, V] of int: c =
%        0  1  2  3  4  5  6  7  8
array2d(V,V,[
          0,11,11,14, 6,11, 4,15, 9,   % 0
          0, 0, 1, 3,15,14,17, 4,11,   % 1
          0,18, 0,17,16,18, 6, 8,12,   % 2
          0,20, 5, 0, 6, 5,15, 4, 5,   % 3
          0,12,13, 3, 0,11,11, 7, 6,   % 4
          0, 4,15, 6, 1, 0, 2, 4, 1,   % 5
          0,12,11, 3, 3,17, 0, 6,18,   % 6
          0,12, 2,17,11, 3, 1, 0,19,   % 7
          0,18,17,10,13,10,16, 1, 0    % 8
]);

int: U = max([c[i,j] | i in V, j in V]); % max single-arc capacity (20)

% Decision variables: flow on each directed arc
array[V, V] of var 0..U: f;

% Capacity constraints (force f=0 where no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= c[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net flow into sink (equivalently out of source)
var 0..10000: maxFlow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxFlow;

output [
  "Maximum flow (TB/hour) = ", show(maxFlow), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j==0 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n" | i in V ])
];