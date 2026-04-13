% Maximum flow in a directed network (cities 0..8)

% Parameters
int: nCities = 9;
set of int: CITIES = 0..nCities-1;

int: source = 0;
int: sink   = 8;

% Capacity matrix (0 => no arc). Use array2d to force 0-based indexing.
array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES,
  [
    0,  0, 20, 10,  0,  2, 11,  5, 12,
    7,  0,  5,  9,  9, 16,  1, 17,  7,
    3, 17,  0,  1,  5, 18, 13, 12, 14,
    9, 10,  2,  0, 10, 11, 11,  5, 10,
    7,  5,  1, 19,  0, 19, 12, 14, 15,
   16,  4,  6, 15, 19,  0,  0,  0, 20,
    3,  0, 17, 16, 19,  8,  0,  8,  9,
   14, 11, 13, 17, 10, 13, 20,  0, 16,
   20,  5, 20, 16,  0, 15,  1, 12,  0
  ]);

int: maxCap = max([cap[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;
var 0..sum(j in CITIES)(cap[source,j]): totalFlow;

% Constraints

% Capacity constraints (also forces flow=0 when cap=0)
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in CITIES) (flow[i,i] = 0);

% Flow conservation for intermediate cities
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

% Define total flow as net outflow from source
constraint totalFlow =
  sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Ensure sink net inflow equals total flow
constraint totalFlow =
  sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

% Objective
solve maximize totalFlow;