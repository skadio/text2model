% Parameters
int: n = 7;                              % number of substations (nodes)
set of int: N = 0..n-1;                  % node indices
int: source = 0;                         % Main Power Plant
int: sink = 6;                           % Central Hub

array[N, N] of int: cap =                % capacity matrix (MW); 0 means no arc
[
| 0, 16,  6, 16,  2, 17, 15 |
| 7,  0, 13,  3,  0,  8, 17 |
| 3, 17,  0, 18, 11, 18, 11 |
| 9,  0, 15,  0,  3,  8, 10 |
| 3,  6,  1, 16,  0, 13, 10 |
|15, 20,  2,  6, 18,  0,  9 |
| 4,  6,  8, 13, 16, 10,  0 |
];

int: totalCapOutSource = sum(j in N)(cap[source, j]); % simple upper bound on max flow

% Variables
array[N, N] of var 0..totalCapOutSource: flow; % flow on arc i->j (MW)
var 0..totalCapOutSource: maxFlow;              % total flow from source to sink

% Constraints

% --- Capacity / existence of arcs ---
% Enforce arc capacities; if cap[i,j] = 0 then no flow is allowed on i->j.
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation (Kirchhoff) ---
% For all intermediate nodes, inflow equals outflow.
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% --- Define maxFlow via net flow at source and sink ---
% Total flow sent from source equals maxFlow (net outflow at source).
constraint
  maxFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Total flow received at sink equals maxFlow (net inflow at sink).
constraint
  maxFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize maxFlow;