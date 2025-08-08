% Maximum Flow Problem

include "globals.mzn";

% Data declarations (to be provided in the .dzn file)
int: n;                     % number of nodes
int: num_edges;             % number of edges/arcs
array[1..num_edges, 1..2] of int: E; % E[i,1] = tail node, E[i,2] = head node for arc i
array[1..num_edges] of int: a;       % capacity of each arc
int: s;                     % source node
int: t;                     % sink node

% Upper bound for each flow decision variable
int: U = max(a);

% Decision variables: flow on each arc, must lie between 0 and its capacity.
% We declare with a common upper bound U and then constrain each arc to not exceed its actual capacity.
array[1..num_edges] of var 0..U: flow;
constraint forall(i in 1..num_edges)( flow[i] <= a[i] );

% Variable representing the total flow pushed from source to sink.
var int: totalFlow;

% Flow conservation constraints:
% For each node v:
%   - If v is the source, then (outflow - inflow) equals totalFlow.
%   - If v is the sink, then (outflow - inflow) equals -totalFlow.
%   - Otherwise, inflow equals outflow.
constraint
  forall(v in 1..n)(
    let {
      var int: out_v = sum(i in 1..num_edges where E[i,1] = v)(flow[i]),
      var int: in_v  = sum(i in 1..num_edges where E[i,2] = v)(flow[i])
    } in
    if v = s then 
      out_v - in_v = totalFlow
    else if v = t then 
      out_v - in_v = -totalFlow
    else 
      out_v - in_v = 0
  );

% The objective is to maximize the total flow
solve maximize totalFlow;

% Output the maximum flow and the flow on each arc.
output [
  "Total Flow = ", show(totalFlow), "\n",
  "Flow per arc:\n",
  concat([ "Arc ", show(i), " (", show(E[i,1]), " -> ", show(E[i,2]), "): ", show(flow[i]), "\n" 
           | i in 1..num_edges ])
];