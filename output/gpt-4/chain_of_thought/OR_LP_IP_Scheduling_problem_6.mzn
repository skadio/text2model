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
constraint forall(i in 2..n-1)(sum(j in 1..num_edges | E[j,1] = i)(f[j]) = sum(j in 1..num_edges | E[j,2] = i)(f[j]));

% Flow capacity constraints for each arc
constraint forall(i in 1..num_edges)(f[i] <= a[i]);

% Objective
solve maximize sum(j in 1..num_edges | E[j,1] = s)(f[j]) - sum(j in 1..num_edges | E[j,2] = t)(f[j]);