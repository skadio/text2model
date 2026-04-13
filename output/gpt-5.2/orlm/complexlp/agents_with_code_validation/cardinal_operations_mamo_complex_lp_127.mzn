% Maximum flow from source (0) to sink (8) in a directed capacitated network

int: n = 9;
set of int: N = 0..n-1;

int: source = 0;
int: sink = 8;

array[N, N] of int: cap =
array2d(N, N, [
  % i=0
   0, 13, 19, 17,  7,  7, 11,  7,  7,
  % i=1
   9,  0, 19, 20, 10, 19, 20, 19,  3,
  % i=2
   0, 16,  0,  0, 10,  2, 14,  9,  9,
  % i=3
   6,  0,  5,  0,  7, 18, 15, 20,  7,
  % i=4
  18, 19, 12,  0,  0, 16, 20, 10,  4,
  % i=5
   3,  4,  8,  9, 20,  0,  7,  8,  1,
  % i=6
   3, 14, 14, 16,  1, 12,  0, 10, 10,
  % i=7
   9, 20, 19,  4,  9, 16,  1,  0,  6,
  % i=8
   0, 15, 14, 18, 18, 11, 18,  0,  0
]);

int: maxCap = max([cap[i,j] | i in N, j in N]);
int: maxTotalFlow = sum(j in N)(cap[source,j]); % tight safe upper bound for total flow

array[N, N] of var 0..maxCap: flow;
var 0..maxTotalFlow: totalFlow;

% Capacity constraints (cap=0 forces flow=0)
constraint forall(i in N, j in N) (flow[i,j] <= cap[i,j]);

% No self-loops
constraint forall(i in N) (flow[i,i] = 0);

% Flow conservation at intermediate nodes
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(j in N)(flow[k,j]) = sum(i in N)(flow[i,k])
  );

% Define total flow as net outflow from source
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Enforce the same total flow as net inflow to sink
constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

solve maximize totalFlow;

output [
  "totalFlow=", show(totalFlow), "\n"
];