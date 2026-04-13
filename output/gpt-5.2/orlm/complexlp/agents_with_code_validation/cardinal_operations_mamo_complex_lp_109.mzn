% Maximum flow in a directed network (nodes 0..8)

% Parameters
int: nNodes = 9;
set of int: N = 0..nNodes-1;
int: source = 0;
int: sink   = 8;

% Capacity matrix (packets per hour)
% Use array2d to coerce literal (1..9,1..9) into desired index set (0..8,0..8)
array[N, N] of int: cap =
  array2d(N, N,
  [ 0, 14, 20,  7,  9,  1,  4,  8, 19,
    3,  0, 15, 12, 17,  0, 15,  3,  3,
   11,  8,  0,  1, 19, 16,  5,  1,  2,
   13, 13,  2,  0, 16, 20, 16, 17,  3,
    6, 15,  7,  3,  0, 18,  1,  3,  9,
   15, 20,  8,  4,  6,  0,  3,  1,  4,
    5, 15, 19,  4, 15, 12,  0,  3,  8,
    7, 14, 13, 12,  9, 10,  3,  0,  4,
    3, 12,  6,  6,  1, 11,  6,  1,  0 ]);

int: totalCapUpper = sum(i in N, j in N)(cap[i,j]);

% Variables
array[N, N] of var 0..totalCapUpper: flow;
var 0..totalCapUpper: maxThroughput;

% Constraints

% Capacity constraints (also forces flow=0 when cap=0)
constraint forall(i in N, j in N)(
  flow[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in N where v != source /\ v != sink)(
  sum(i in N)(flow[i,v]) = sum(j in N)(flow[v,j])
);

% Define throughput as net outflow from source
constraint
  maxThroughput = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Consistency with net inflow to sink
constraint
  maxThroughput = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

solve maximize maxThroughput;

output [
  "maxThroughput=", show(maxThroughput), "\n"
];