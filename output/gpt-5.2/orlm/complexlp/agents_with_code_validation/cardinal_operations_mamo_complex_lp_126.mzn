% Maximum flow in a directed capacitated network (8 hubs: 0..7)

% Parameters
int: n = 8;
set of int: N = 0..n-1;
int: source = 0;
int: sink = 7;

% Capacity matrix indexed by 0..7 x 0..7
array[N, N] of int: cap =
  array2d(N, N, [
      0, 19,  5,  7,  0, 17, 19,  9,
      6,  0, 15, 15, 16,  8,  5,  0,
      5,  6,  0,  3, 10,  7,  6,  3,
      8,  2,  6,  0,  5, 17,  0,  1,
     17,  4, 10, 10,  0,  6, 15, 14,
     11, 11,  9,  7,  7,  0, 16, 19,
     13, 19, 14, 14, 16,  1,  0, 16,
      0, 14,  0, 17,  1,  7,  9,  0
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

% Flow conservation at intermediate nodes
constraint forall(k in N where k != source /\ k != sink) (
  sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
);

% Total flow definition: net outflow from source equals net inflow to sink
constraint totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);
constraint totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize totalFlow;