include "globals.mzn";

int: n;                           % number of nodes
int: num_edges;                   % number of directed edges
array[1..num_edges,1..2] of int: E;   % each edge as (from,to)
array[1..num_edges] of int: a;        % capacity of each edge
int: s;                           % source node
int: t;                           % sink node

% flow on each edge: 0 .. capacity of that edge
array[1..num_edges] of var 0..a[i] : flow;

% amount of flow that leaves the source and enters the sink
var 0..sum(a) : flowValue;

% conservation of flow at each node
constraint
  forall(i in 1..n) (
    let {
      set of int: inEdges  = {e | e in 1..num_edges where E[e,2] == i};
      set of int: outEdges = {e | e in 1..num_edges where E[e,1] == i};
    } in
    if i == s then
      sum(outEdges) - sum(inEdges) == flowValue          % source
    elseif i == t then
      sum(inEdges) - sum(outEdges) == flowValue          % sink
    else
      sum(inEdges) == sum(outEdges)                      % intermediate node
    endif
  );

solve maximize flowValue;

output [
  "Max flow = ", show(flowValue), "\n",
  "Flows on edges:\n",
  concat([ show(i) ++ ": " ++ show(flow[i]) ++ "\n" | i in 1..num_edges ])
];