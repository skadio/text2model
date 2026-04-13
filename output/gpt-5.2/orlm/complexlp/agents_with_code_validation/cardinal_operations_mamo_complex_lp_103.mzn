% Maximum flow in a directed capacitated network

% Parameters
int: nCities = 8;
set of int: CITIES = 0..nCities-1;

int: source = 0;
int: sink   = 7;

% Road capacities (0 => no direct road)
array[CITIES, CITIES] of int: cap =
array2d(CITIES, CITIES, [
  0, 11,  1,  6,  4,  5,  7,  1,
  3,  0, 15, 15, 16,  9, 14, 12,
 19,  9,  0,  5,  9, 11, 16,  3,
 15,  1, 14,  0,  0,  4,  1, 15,
  8, 16,  7,  3,  0, 16, 10, 11,
  7,  8,  1, 11, 19,  0,  3,  3,
  2, 19,  2,  6, 12, 20,  0,  6,
 15, 17,  4,  7,  8,  2, 16,  0
]);

int: maxCap = max([cap[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;
var 0..(nCities * maxCap): totalFlow;

% Constraints

% Capacity constraints (cap=0 forces flow=0)
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% No self loops
constraint forall(i in CITIES) (flow[i,i] = 0);

% Flow conservation for intermediate nodes
constraint forall(v in CITIES where v != source /\ v != sink) (
  sum(i in CITIES)(flow[i,v]) = sum(j in CITIES)(flow[v,j])
);

% Total flow defined as net outflow from source (and equals net inflow to sink)
constraint totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);
constraint totalFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

solve maximize totalFlow;

output [
  "totalFlow=", show(totalFlow), "\n"
];