% Parameters
int: n; % Number of nodes in the network
int: num_edges; % Number of arcs in the network
array[1..num_edges, 1..2] of int: E; % Set of arcs represented as pairs of nodes
array[1..num_edges] of int: a; % Capacities of each arc in the network
int: s; % Source node
int: t; % Sink node

% Variables
array[1..n, 1..n] of var 0..max(a): flow; % Flow on each arc
var 0..sum(a): total_flow; % Total flow through the network

% Constraints

% The flow on each arc must be less than or equal to its capacity
constraint forall(i in 1..num_edges) (
    flow[E[i,1], E[i,2]] <= a[i]
);

% The total flow out of the source node must be equal to the total flow
constraint sum(i in 1..num_edges where E[i,1] = s)(flow[E[i,1], E[i,2]]) = total_flow;

% The total flow into the sink node must be equal to the total flow
constraint sum(i in 1..num_edges where E[i,2] = t)(flow[E[i,1], E[i,2]]) = total_flow;

% The flow into each node (except the source and sink) must be equal to the flow out of it
constraint forall(i in 1..n where i != s /\ i != t) (
    sum(j in 1..num_edges where E[j,1] = i)(flow[E[j,1], E[j,2]]) = 
    sum(j in 1..num_edges where E[j,2] = i)(flow[E[j,1], E[j,2]])
);

% Objective
solve maximize total_flow;