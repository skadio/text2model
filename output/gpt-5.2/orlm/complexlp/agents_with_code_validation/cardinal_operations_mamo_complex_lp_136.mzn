% Maximum flow from source hub 0 to sink hub 6

int: nHubs = 7;
set of int: H = 0..nHubs-1;

int: source = 0;
int: sink = 6;

% Capacity matrix (0 => no arc). Use array2d to coerce indices to 0..6.
array[H, H] of int: cap =
  array2d(H, H, [
     0, 15,  2, 16,  3,  5,  3,
     7,  0,  0,  0, 19, 15, 16,
    11, 14,  0, 14,  8, 11,  6,
    17, 11, 11,  0, 11, 16, 19,
    10,  4, 17, 20,  0, 12, 17,
     3,  0,  4,  5, 20,  0,  4,
    15,  2, 15, 18, 17,  7,  0
  ]);

int: maxCap = max([cap[i,j] | i in H, j in H]);
int: maxTotalOut = sum(j in H)(cap[source, j]);

array[H, H] of var 0..maxCap: flow;
var 0..maxTotalOut: totalFlow;

% Capacity constraints (includes enforcing 0 capacity => 0 flow)
constraint forall(i in H, j in H) (
  flow[i,j] <= cap[i,j]
);

% Flow conservation at intermediate hubs
constraint forall(k in H where k != source /\ k != sink) (
  sum(i in H)(flow[i,k]) = sum(j in H)(flow[k,j])
);

% Define totalFlow as net outflow from source and net inflow to sink
constraint totalFlow = sum(j in H)(flow[source,j]) - sum(i in H)(flow[i,source]);
constraint totalFlow = sum(i in H)(flow[i,sink]) - sum(j in H)(flow[sink,j]);

solve maximize totalFlow;

output [
  "totalFlow=", show(totalFlow), "\n"
];