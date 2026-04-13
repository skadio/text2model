include "globals.mzn";

% Max flow from source 0 to sink 8 on a directed graph with 9 nodes.
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix cap[i,j] (0 means no direct arc).
array[V, V] of int: cap =
array2d(V, V, [
  % to:   0  1  2  3  4  5  6  7  8
          0,15, 1, 9,18,12,18, 6,17,  % from 0
         14, 0,13,11,14,10,15, 4,15,  % from 1
          3, 0, 0, 2,14,16, 7,12, 4,  % from 2
          5,20, 0, 0, 9, 1,12, 1,20,  % from 3
         11,18,12, 3, 0, 4,16,15, 2,  % from 4
         13, 8, 8, 6, 4, 0, 8,10,11,  % from 5
         12, 1, 3, 4,11, 8, 0,10,19,  % from 6
         18, 3, 9, 5, 9,17,10, 0,13,  % from 7
          9, 8,12, 2, 5, 2,16, 5, 0   % from 8
]);

% Decision variables: flow[i,j] on each arc (bounded by capacity).
array[V, V] of var 0..20: flow;

% Capacity constraints (and force zero where no arc or self-loop).
constraint forall(i in V, j in V) (
  if i = j \/ cap[i,j] = 0 then
    flow[i,j] = 0
  else
    flow[i,j] <= cap[i,j]
  endif
);

% Flow conservation at intermediate nodes.
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(flow[i,v]) = sum(j in V)(flow[v,j])
);

% Objective: maximize total flow leaving source (equivalently entering sink).
var 0..1000: maxFlow = sum(j in V)(flow[s,j]);

solve maximize maxFlow;

output [
  "Maximum flow from station ", show(s), " to station ", show(t), " = ",
  show(maxFlow), " TB/hour\n",
  "Flow matrix (rows=from, cols=to):\n",
  show(flow), "\n"
];