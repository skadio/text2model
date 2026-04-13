% Maximum flow from City 0 (source) to City 5 (sink)

% Parameters
int: nCities = 6;
set of int: CITIES = 0..nCities-1;
int: source = 0;
int: sink = 5;

% Capacities (0 means no direct link)
array[CITIES, CITIES] of int: cap = array2d(CITIES, CITIES,
[
  0, 14, 15, 13,  0,  4,
 10,  0,  7, 18,  9,  5,
 11,  0,  0,  7, 13,  6,
  7, 11, 18,  0, 17,  2,
 19,  8, 15, 15,  0,  5,
 10, 19, 17,  2,  3,  0
]);

int: maxCap = max([cap[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;
var 0..sum(j in CITIES)(cap[source,j]): totalFlow;

% Constraints

% Respect capacities (this also forces flow=0 where no arc exists)
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(j in CITIES)(flow[k,j]) = sum(i in CITIES)(flow[i,k])
);

% Define total flow as net outflow from source (equivalently net inflow to sink)
constraint totalFlow =
  sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Objective
solve maximize totalFlow;