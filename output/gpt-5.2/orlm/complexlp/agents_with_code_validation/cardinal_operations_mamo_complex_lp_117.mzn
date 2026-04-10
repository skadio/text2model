% Maximum flow from source (0) to sink (8) in a directed capacitated network

% Parameters
int: nSectors = 9;
set of int: SECTOR = 0..nSectors-1;

int: source = 0;
int: sink   = 8;

% Capacity matrix (0 => no arc). Use array2d to coerce indices to 0..8 x 0..8.
array[SECTOR, SECTOR] of int: cap =
  array2d(SECTOR, SECTOR,
  [
    0,  7,  4, 17,  4, 18, 17,  5, 14,
    2,  0, 11, 10,  1, 19,  6, 16, 13,
    8, 15,  0,  5,  1,  5, 11, 17, 18,
    2,  5,  0,  0,  6, 17,  1, 16, 14,
   15,  6, 20, 15,  0,  7, 13,  6, 19,
   15,  2,  8,  2,  3,  0,  2,  9,  2,
   10, 12, 11, 10, 19,  9,  0, 17,  1,
    0, 20, 15, 19, 20, 18, 14,  0,  8,
   16, 13,  3,  3, 20, 19,  2,  7,  0
  ]);

% Upper bound on any s-t flow (sum of outgoing capacity from source)
int: maxFlowUB = sum(j in SECTOR)(cap[source,j]);

% Variables
array[SECTOR, SECTOR] of var 0..maxFlowUB: flow;
var 0..maxFlowUB: maxFlow;

% Constraints

% Capacity constraints
constraint forall(i in SECTOR, j in SECTOR) (
  flow[i,j] <= cap[i,j]
);

% No self-loops
constraint forall(i in SECTOR) (
  flow[i,i] = 0
);

% Flow conservation on intermediate nodes
constraint forall(k in SECTOR where k != source /\ k != sink) (
  sum(i in SECTOR)(flow[i,k]) = sum(j in SECTOR)(flow[k,j])
);

% Define maxFlow as net outflow from source
constraint
  maxFlow = sum(j in SECTOR)(flow[source,j]) - sum(i in SECTOR)(flow[i,source]);

% Consistency: same value as net inflow to sink
constraint
  maxFlow = sum(i in SECTOR)(flow[i,sink]) - sum(j in SECTOR)(flow[sink,j]);

solve maximize maxFlow;

output [
  "maxFlow = ", show(maxFlow), "\n"
];