include "globals.mzn";

% Max-flow from source 0 to sink 8 on a directed graph with capacities.
% Data is embedded as given in the description.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
% rows = from-node, cols = to-node
% Missing/self arcs are set to 0.
[
% to:  0  1  2  3  4  5  6  7  8
      0, 4, 7,15, 4, 7, 2,10,12,  % from 0
      0, 0,17, 2, 5, 1,10,14, 5,  % from 1
      0, 7, 0,17, 9,13,10, 7, 5,  % from 2
      0,16, 4, 0,11, 9,12,18,12,  % from 3
      0, 3, 0,18, 0, 5, 2, 0,19,  % from 4 (no arc to 7 given)
      0,15, 7,20,20, 0,20,12, 9,  % from 5
      0, 8,14,13, 1,17, 0,10,19,  % from 6
      0, 5, 5,16, 5, 7, 3, 0,19,  % from 7
      0,19,18, 0, 4, 7, 1,20, 0   % from 8
];

array[V, V] of var 0..20: f; % flow on each directed arc (upper bounded below by cap via constraints)

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net flow out of source (equivalently into sink)
var int: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (thousands of units per hour) = ", show(maxflow), "\n",
  "Flow matrix f[from,to]:\n",
  show(f), "\n"
];