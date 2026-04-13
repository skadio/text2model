% Parameters
int: nHubs = 9;                          % number of hubs (0..8)
set of int: HUB = 0..nHubs-1;            % hub indices
int: source = 0;                         % source hub
int: sink   = 8;                         % destination hub

% capacity[u,v] in thousands of units per hour; 0 means no arc
array[HUB, HUB] of int: capacity = array2d(HUB, HUB,
[
  % row 0
   0, 4, 7,15, 4, 7, 2,10,12,
  % row 1
   0, 0,17, 2, 5, 1,10,14, 5,
  % row 2
   0, 7, 0,17, 9,13,10, 7, 5,
  % row 3
   0,16, 4, 0,11, 9,12,18,12,
  % row 4
   0, 3, 0,18, 0, 5, 2, 0,19,
  % row 5
   0,15, 7,20,20, 0,20,12, 9,
  % row 6
   0, 8,14,13, 1,17, 0,10,19,
  % row 7
   0, 5, 5,16, 5, 7, 3, 0,19,
  % row 8
   0,19,18, 0, 4, 7, 1,20, 0
]);

% An upper bound on any feasible s-t flow (sum of outgoing capacities from source)
int: maxFlowUB = sum(v in HUB)(capacity[source, v]);

% Variables
array[HUB, HUB] of var 0..maxFlowUB: flow;  % flow[u,v] in thousands of units per hour
var 0..maxFlowUB: max_flow;                 % total flow from source to sink

% Constraints

% Capacity limits and no self-loops
constraint
  forall(u in HUB, v in HUB) (
    (u = v -> flow[u,v] = 0) /\
    flow[u,v] <= capacity[u,v]
  );

% Disallow flow on non-existent roads (capacity = 0)
constraint
  forall(u in HUB, v in HUB where u != v /\ capacity[u,v] = 0) (
    flow[u,v] = 0
  );

% Flow conservation at intermediate hubs (neither source nor sink)
constraint
  forall(k in HUB where k != source /\ k != sink) (
    sum(i in HUB)(flow[i,k]) = sum(j in HUB)(flow[k,j])
  );

% Define total s-t flow value as net outflow of the source
constraint
  max_flow = sum(j in HUB)(flow[source,j]) - sum(i in HUB)(flow[i,source]);

% Objective
solve maximize max_flow;