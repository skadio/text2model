% Parameters
int: nHubs = 8;
set of int: HUB = 0..nHubs-1;
int: source = 0;
int: sink = 7;

% Capacity matrix (0 = no arc)
array[HUB, HUB] of int: cap =
array2d(HUB, HUB, [
  % from 0
  0,15,19, 4, 4, 3,20,17,
  % from 1
  8, 0, 6, 5,20, 3,15, 1,
  % from 2
  11,13, 0,16,15, 7,10,13,
  % from 3
  17,20, 6, 0,11, 3, 2, 0,
  % from 4
  10,15, 5, 0, 0, 9, 9,15,
  % from 5
   9,17, 5, 1, 9, 0,20, 2,
  % from 6
   4,16,10, 2, 1, 6, 0, 4,
  % from 7 (no outgoing arcs needed)
   0, 0, 0, 0, 0, 0, 0, 0
]);

int: maxCap = max([cap[i,j] | i in HUB, j in HUB]);

% Variables
array[HUB, HUB] of var 0..maxCap: flow;
var 0..sum(j in HUB)(cap[source,j]): totalFlow;

% Constraints

% Capacity constraints (cap=0 forces flow=0)
constraint forall(i in HUB, j in HUB) (
  flow[i,j] <= cap[i,j]
);

% No self loops
constraint forall(i in HUB) (flow[i,i] = 0);

% Flow conservation at intermediate hubs
constraint forall(h in HUB where h != source /\ h != sink) (
  sum(i in HUB)(flow[i,h]) = sum(j in HUB)(flow[h,j])
);

% Define total flow from source (net outflow)
constraint totalFlow =
  sum(j in HUB)(flow[source,j]) - sum(i in HUB)(flow[i,source]);

% Ensure sink net inflow equals total flow
constraint totalFlow =
  sum(i in HUB)(flow[i,sink]) - sum(j in HUB)(flow[sink,j]);

solve maximize totalFlow;