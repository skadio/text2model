% Parameters
int: nCities = 9;                         % number of cities (0..8)
set of int: CITIES = 0..nCities-1;        % city indices

int: source = 0;                          % Central Hub
int: sink   = 8;                          % Key Distribution Center

% Capacity matrix (0 means no direct route)
array[CITIES, CITIES] of int: cap =
[
| 0,  1, 16,  8, 18,  4,  0,  8,  5 |
|15,  0, 11,  8, 13,  2,  1,  7,  6 |
|15,  4,  0,  3,  1, 13, 13, 11,  9 |
| 4, 16,  8,  0, 12, 18, 19,  8, 11 |
| 4, 19,  3,  2,  0,  6,  1, 13, 14 |
| 6, 19, 15, 10, 16,  0, 17, 15, 17 |
|13,  7, 13,  4, 14,  3,  0,  8,  8 |
|10,  6, 19,  1, 12,  6,  9,  0, 14 |
| 0,  0,  0,  0,  0,  0,  0,  0,  0 |
];

% Upper bound on total flow (safe bound: sum of outgoing capacities from source)
int: maxTotalFlow = sum(j in CITIES)(cap[source,j]);

% Variables
array[CITIES, CITIES] of var 0..maxTotalFlow: flow;  % flow on each directed arc (i->j)
var 0..maxTotalFlow: totalFlow;                      % total shipped from source to sink

% Constraints

% Capacity upper bounds for all arcs
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% Flow conservation (except at source and sink)
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

% Define totalFlow as net outflow from source and net inflow to sink
constraint totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);
constraint totalFlow = sum(i in CITIES)(flow[i,sink])   - sum(j in CITIES)(flow[sink,j]);

% 1) Disallow self-loops explicitly (no flow from a city to itself)
constraint forall(i in CITIES) (
  flow[i,i] = 0
);

% 2) Enforce zero flow on non-arcs (where capacity is 0, there is no direct route)
constraint forall(i in CITIES, j in CITIES where cap[i,j] = 0) (
  flow[i,j] = 0
);

% 3) Ensure source has no incoming flow (strengthening)
constraint sum(i in CITIES)(flow[i,source]) = 0;

% 4) Ensure sink has no outgoing flow (strengthening)
constraint sum(j in CITIES)(flow[sink,j]) = 0;

% Objective
solve maximize totalFlow;