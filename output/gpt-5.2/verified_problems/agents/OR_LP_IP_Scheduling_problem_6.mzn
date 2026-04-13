% Parameters
int: n;                                % Number of nodes
set of int: N = 1..n;                  % Node index set

int: num_edges;                        % Number of arcs
set of int: EDGES = 1..num_edges;      % Arc index set

array[EDGES, 1..2] of int: E;          % Arc endpoints: E[e,1]=tail (from), E[e,2]=head (to)
array[EDGES] of int: a;                % Capacity of each arc (same order as EDGES)

int: s;                                % Source node
int: t;                                % Sink node

% Variables
array[EDGES] of var 0..max(a): f;      % Flow on each arc (bounded by max capacity)
var 0..sum(a): total_flow;             % Total flow value (bounded by sum of capacities)

% Constraints

% Capacity constraints: flow on each arc cannot exceed its capacity
constraint
  forall(e in EDGES) (
    f[e] <= a[e]
  );

% Flow conservation at intermediate nodes (all nodes except source and sink):
% total inflow equals total outflow
constraint
  forall(v in N where v != s /\ v != t) (
    sum(e in EDGES where E[e,2] == v)(f[e]) =
    sum(e in EDGES where E[e,1] == v)(f[e])
  );

% Define total_flow as net outflow from the source
constraint
  total_flow =
    sum(e in EDGES where E[e,1] == s)(f[e]) -
    sum(e in EDGES where E[e,2] == s)(f[e]);

% Ensure consistency: total_flow equals net inflow to the sink
constraint
  total_flow =
    sum(e in EDGES where E[e,2] == t)(f[e]) -
    sum(e in EDGES where E[e,1] == t)(f[e]);

% Objective
solve maximize total_flow;