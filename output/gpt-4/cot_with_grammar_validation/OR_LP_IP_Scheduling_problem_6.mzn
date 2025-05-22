% Parameters
int: n; % Number of nodes in the network
int: num_edges; % Number of arcs in the network
array[1..num_edges, 1..2] of int: E; % Set of arcs represented as pairs of nodes
array[1..num_edges] of int: a; % Capacities of each arc in the network
int: s; % Source node
int: t; % Sink node

% Variables
array[1..num_edges] of var 0..max(a): f; % Flow on each arc

% Constraints
% Flow conservation constraints for each node
constraint forall(i in 1..n)(sum(j in 1..num_edges)(if E[j,1] = i then f[j] else 0 endif) = sum(j in 1..num_edges)(if E[j,2] = i then f[j] else 0 endif));

% Flow capacity constraints for each arc
constraint forall(i in 1..num_edges)(f[i] <= a[i]);

% Objective
% Maximize the total flow from the source to the sink
solve maximize sum(i in 1..num_edges)(if E[i,1] = s then f[i] else 0 endif - if E[i,2] = s then f[i] else 0 endif);