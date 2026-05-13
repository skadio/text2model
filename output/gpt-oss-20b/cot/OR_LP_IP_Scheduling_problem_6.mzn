% Parameters
int: n; % Number of nodes
int: num_edges; % Number of arcs
array[1..num_edges, 1..2] of int: E; % Edge list: E[i,1] = from, E[i,2] = to
array[1..num_edges] of int: a; % Capacities of each arc
int: s; % Source node
int: t; % Sink node

% Variables
array[1..num_edges] of var 0..max(a): flow; % Flow on each arc
var 0..max(a): flow_value; % Total flow from source to sink

% Constraints
constraint
  % Capacity constraints
  forall(i in 1..num_edges) (
    flow[i] <= a[i]
  );

constraint
  % Flow conservation for intermediate nodes
  forall(k in 1..n where k != s /\ k != t) (
    sum(i in 1..num_edges where E[i,2] == k) flow[i] =
    sum(i in 1..num_edges where E[i,1] == k) flow[i]
  );

constraint
  % Source node: outflow - inflow = flow_value
  sum(i in 1..num_edges where E[i,1] == s) flow[i] -
  sum(i in 1..num_edges where E[i,2] == s) flow[i] = flow_value;

constraint
  % Sink node: inflow - outflow = flow_value
  sum(i in 1..num_edges where E[i,2] == t) flow[i] -
  sum(i in 1..num_edges where E[i,1] == t) flow[i] = flow_value;

% Objective
solve maximize flow_value;