% Maximum flow in a directed network (embedded data)

% Parameters
int: n = 8;
set of int: N = 0..n-1;

int: source = 0;
int: sink   = 7;

% Capacity matrix (0 means no arc). Use array2d to match index sets 0..7,0..7.
array[N, N] of int: cap =
  array2d(N, N,
  [
     0,  2,  1,  1,  8, 17,  6,  7,
     4,  0, 14, 14, 13, 19,  4, 19,
     6, 16,  0,  3, 10,  7, 18, 10,
    19,  4, 15,  0,  6,  1, 17,  9,
    12, 15,  3, 14,  0, 18, 20, 14,
    20,  5, 19,  9, 20,  0, 10,  6,
     9, 14, 12, 16, 19,  3,  0, 10,
    20, 16,  6, 16,  8, 16,  4,  0
  ]);

int: maxCap = max([cap[i,j] | i in N, j in N]);
int: maxTotalOutOfSource = sum(j in N)(cap[source,j]);

% Decision variables
array[N, N] of var 0..maxCap: flow;
var 0..maxTotalOutOfSource: totalFlow;

% Constraints
constraint forall(i in N, j in N) (flow[i,j] <= cap[i,j]);
constraint forall(i in N) (flow[i,i] = 0);

constraint
  forall(v in N where v != source /\ v != sink) (
    sum(i in N)(flow[i,v]) = sum(j in N)(flow[v,j])
  );

constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

solve maximize totalFlow;

output [
  "totalFlow=", show(totalFlow), "\n"
];