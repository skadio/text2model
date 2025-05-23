include "globals.mzn";

% Parameters
int: n; % Number of nodes
int: num_edges; % Number of arcs
array[1..num_edges, 1..2] of int: E; % Set of arcs
array[1..num_edges] of int: a; % Capacities of each arc
int: s; % Source node
int: t; % Sink node

% Variables
array[1..num_edges] of var 0..max(a): f; % Flow on each arc

% Constraints
constraint forall(i in 1..n)(sum(j in 1..num_edges)(if E[j,1] = i then f[j] else if E[j,2] = i then -f[j] else 0 endif endif) = if i = s then sum(f) else if i = t then -sum(f) else 0 endif endif);

constraint forall(i in 1..num_edges)(f[i] <= a[i]);

% Objective
var int: max_flow = sum(f);
solve maximize max_flow;

% Output
output ["Maximum flow: ", show(max_flow), "\n"];
output ["Flow on each arc: ", show(f), "\n"];