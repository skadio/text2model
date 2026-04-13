% Parameters
int: n = 7;                           % number of substations (nodes)
set of int: N = 0..n-1;               % node indices
int: source = 0;                      % Main Power Plant
int: sink   = 6;                      % Central Hub

% Capacity matrix cap[i,j] (MW). 0 means no direct line.
array[N, N] of int: cap = array2d(N, N,
[
  0, 16,  6, 16,  2, 17, 15,
  7,  0, 13,  3,  0,  8, 17,
  3, 17,  0, 18, 11, 18, 11,
  9,  0, 15,  0,  3,  8, 10,
  3,  6,  1, 16,  0, 13, 10,
 15, 20,  2,  6, 18,  0,  9,
  4,  6,  8, 13, 16, 10,  0
]);

% Simple upper bound for the objective (used to bound flow variables)
int: total_out_cap_source = sum(j in N)(cap[source,j]);
int: total_in_cap_sink    = sum(i in N)(cap[i,sink]);
int: maxFlowUB = min(total_out_cap_source, total_in_cap_sink);

% Variables
array[N, N] of var 0..maxFlowUB: flow;  % flow[i,j] sent on arc i->j (MW)
var 0..maxFlowUB: maxFlow;              % total flow from source to sink (MW)

% Constraints

% Capacity feasibility on each directed arc (respect 0 = no connection)
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% No self-loop flow
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% Flow conservation at intermediate substations (neither source nor sink)
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% Define maxFlow as net outflow of source
constraint
  maxFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Define maxFlow as net inflow to sink
constraint
  maxFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize maxFlow;

output [
  "maxFlow = ", show(maxFlow), "\n"
];