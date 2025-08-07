int: n;                          % Number of nodes
int: num_edges;                  % Number of arcs
array[1..num_edges, 1..2] of int: E;  % Arcs represented as pairs of nodes
array[1..num_edges] of int: a;  % Capacities of each arc
int: s;                          % Source node
int: t;                          % Sink node

% Flow variables for each arc
array[1..num_edges] of var 0..max(a): flow;

% Constraints for flow conservation at each node
array[1..n] of var 0..sum(a): inflow;  % Inflow to each node
array[1..n] of var 0..sum(a): outflow; % Outflow from each node

% Inflow and outflow definitions
constraint forall(i in 1..num_edges) (
    inflow[E[i, 2]] = inflow[E[i, 2]] + flow[i]  % Flow into the target node
    -> inflow[E[i, 1]] = inflow[E[i, 1]] - flow[i]  % Flow out of the source node
);

% Conservation of flow constraints
constraint inflow[s] = sum(flow[i] | i in 1..num_edges where E[i, 1] == s);
constraint outflow[t] = sum(flow[i] | i in 1..num_edges where E[i, 2] == t);
constraint forall(i in 1..n where i != s /\ i != t) (
    inflow[i] = outflow[i]
);

% Capacity constraints
constraint forall(i in 1..num_edges) (
    flow[i] <= a[i]
);

% Objective: Maximize the flow into the sink node
var 0..sum(a): total_flow;
constraint total_flow = outflow[t];

solve maximize total_flow;

output [ "Maximum flow = ", show(total_flow), "\n" ];