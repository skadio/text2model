% Parameters
int: n = 8;                              % Number of data centers (nodes)
set of int: N = 0..n-1;                  % Node index set

int: source = 0;                         % Source data center
int: sink   = 7;                         % Destination data center

array[N, N] of int: cap =                % Capacity matrix (Tbps); 0 means no direct link
array2d(N, N,
[
  0,  5, 16, 11,  2, 10, 17,  2,
  8,  0, 14, 14,  2,  7, 11,  1,
 17, 20,  0, 16, 13,  0,  6,  1,
  3, 16, 10,  0, 19, 12,  3, 15,
 15, 12, 19, 18,  0, 14, 12, 15,
  2, 20, 20, 17,  4,  0, 10, 17,
 15, 13, 13,  5, 10, 15,  0, 19,
 10,  3, 14, 11,  5, 20,  4,  0
]);

int: max_cap = max([cap[i,j] | i in N, j in N]);         % Max single-arc capacity
int: max_total_flow = sum([cap[source,j] | j in N]);     % Upper bound on total s->* flow

% Variables
array[N, N] of var 0..max_cap: flow;     % Flow on each directed arc i->j (Tbps)
var 0..max_total_flow: total_flow;       % Total flow sent from source to sink (Tbps)

% Constraints

% Capacity constraints (also enforces non-existence when cap=0 since flow >= 0)
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% No self-loop flow (diagonal is 0 capacity, but state explicitly for clarity)
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% Flow conservation at intermediate nodes (all except source and sink):
% Total inflow equals total outflow.
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% Define total_flow as net outflow from the source (equivalently, net inflow to sink)
constraint
  total_flow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

constraint
  total_flow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize total_flow;