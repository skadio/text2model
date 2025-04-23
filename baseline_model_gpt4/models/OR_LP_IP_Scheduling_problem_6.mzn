include "globals.mzn";

% Number of nodes in the network
int: n;

% Number of arcs in the network
int: num_edges;

% Set of arcs represented as pairs of nodes
array[1..num_edges, 1..2] of int: E;

% Capacities of each arc in the network
array[1..num_edges] of int: a;

% Source node
int: s;

% Sink node
int: t;

% Decision variable: flow on each edge
array[1..num_edges] of var 0..max(a): f;

% Objective: maximize total flow from source to sink
var int: total_flow = sum(i in 1..num_edges)(if E[i,1] = s then f[i] else 0 endif) - sum(i in 1..num_edges)(if E[i,2] = s then f[i] else 0 endif);
maximize total_flow;

% Constraints
% Flow on each edge must not exceed its capacity
constraint forall(i in 1..num_edges)(f[i] <= a[i]);

% Conservation of flow at each node
constraint forall(i in 1..n)(i != s /\ i != t -> sum(j in 1..num_edges)(if E[j,2] = i then f[j] else 0 endif) = sum(j in 1..num_edges)(if E[j,1] = i then f[j] else 0 endif));

% Flow from source must equal flow into sink
constraint sum(i in 1..num_edges)(if E[i,1] = s then f[i] else 0 endif) = sum(i in 1..num_edges)(if E[i,2] = t then f[i] else 0 endif);

solve satisfy;