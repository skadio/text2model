% Parameters
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;          % E[i,1] = tail, E[i,2] = head
array[1..num_edges] of int: a;                % capacities
int: s;                                       
int: t;

set of int: NODES = 1..n;
set of int: EDGES = 1..num_edges;

% Variables
array[EDGES] of var int: f;                   % flow on each arc

% Constraints
constraint
    forall(i in EDGES) (
        0 <= f[i] /\ f[i] <= a[i]             % capacity bounds
    );

constraint
    forall(v in NODES where v != s /\ v != t)(
        sum(i in EDGES where E[i,2] == v)(f[i]) =          % inflow
        sum(i in EDGES where E[i,1] == v)(f[i])            % outflow
    );

% Objective
solve maximize
    sum(i in EDGES where E[i,1] == s)(f[i]) 
  - sum(i in EDGES where E[i,2] == s)(f[i]);