% Maximum flow in a directed network (telecommunications capacities)

% Parameters
int: nNodes = 6;
set of int: N = 0..nNodes-1;
int: source = 0;
int: sink   = 5;

% Capacity matrix (GB/s); 0 means no direct line
array[N, N] of int: cap = array2d(N, N,
[
   0, 14,  9,  8,  7,  8,
   4,  0,  9, 10,  0, 12,
   4, 12,  0, 13, 20, 16,
  10,  8, 12,  0,  0, 18,
   3, 13, 11, 20,  0,  2,
  17,  4,  8,  2, 12,  0
]);

int: maxCap = max([cap[i,j] | i in N, j in N]);

% Variables
array[N, N] of var 0..maxCap: flow;
var 0..sum(j in N)(cap[source,j]): totalFlow;

% Constraints

% Capacity constraints (also forces flow=0 when cap=0)
constraint forall(i in N, j in N) (
  flow[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in N) (
  flow[i,i] = 0
);

% Flow conservation at intermediate nodes
constraint forall(k in N where k != source /\ k != sink) (
  sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
);

% Total flow defined as net outflow from source and net inflow to sink
constraint totalFlow =
  sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

constraint totalFlow =
  sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize totalFlow;

output [
  "Max flow (GB/s) = ", show(totalFlow), "\n"
];