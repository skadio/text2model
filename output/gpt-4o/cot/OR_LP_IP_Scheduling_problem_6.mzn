% Parameters
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;   % E[e,1] = tail, E[e,2] = head
array[1..num_edges] of int: a;         % capacities
int: s;                                 % source node
int: t;                                 % sink   node

set of int: NODES = 1..n;
set of int: EDGES = 1..num_edges;

int: max_cap = max(a);                          
int: total_cap_out_s = sum(e in EDGES where E[e,1] = s)(a[e]);  % bound for total flow

% Variables
array[EDGES] of var 0..max_cap: f;               % flow on each arc
var 0..total_cap_out_s: total_flow;              % objective variable

% Constraints
constraint
    forall(e in EDGES)(
        f[e] <= a[e]                             % capacity on every arc
    );

constraint
    forall(i in NODES where i != s /\ i != t)(
        sum(e in EDGES where E[e,2] = i)(f[e])   % inflow
        =
        sum(e in EDGES where E[e,1] = i)(f[e])   % outflow
    );

constraint
    total_flow =
        sum(e in EDGES where E[e,1] = s)(f[e])   % flow leaving the source
        -
        sum(e in EDGES where E[e,2] = s)(f[e]);  % (minus) flow entering the source

% Objective
solve maximize total_flow;