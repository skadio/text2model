% Parameters
int: n;
int: num_edges;
set of int: N = 1..n;
set of int: EDGES = 1..num_edges;

array[EDGES, 1..2] of int: E;     % E[e,1] = tail, E[e,2] = head
array[EDGES] of int: a;            % capacities for each arc, aligned with EDGES

int: s;                            % source node
int: t;                            % sink   node

int: max_cap     = max(a);         % largest individual capacity
int: total_cap   = sum(a);         % upper bound for the total flow

% Variables
array[EDGES] of var 0..max_cap: f; % flow on each arc
var 0..total_cap: F;               % total flow from s to t

% Constraints
constraint
    forall(e in EDGES)(
        f[e] <= a[e]               % capacity constraints
    );

set of int: N_internal = {u | u in N where u != s /\ u != t};

constraint
    forall(u in N_internal)(
        sum([f[e] | e in EDGES where E[e,2] = u]) =   % inflow
        sum([f[e] | e in EDGES where E[e,1] = u])     % outflow
    );

constraint
    F = sum([f[e] | e in EDGES where E[e,1] = s])     % net outflow from source
      - sum([f[e] | e in EDGES where E[e,2] = s]);

constraint
    F = sum([f[e] | e in EDGES where E[e,2] = t])     % net inflow to sink
      - sum([f[e] | e in EDGES where E[e,1] = t]);

% Objective
solve maximize F;