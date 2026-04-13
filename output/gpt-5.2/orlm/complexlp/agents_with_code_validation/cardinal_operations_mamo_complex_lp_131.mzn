% Maximum flow in a directed capacitated network (cities 0..6)

int: nCities = 7;
set of int: CITIES = 0..nCities-1;

int: source = 0;
int: sink   = 6;

% Capacity matrix cap[i,j] (0 means no direct line)
array[CITIES, CITIES] of int: cap = array2d(CITIES, CITIES, [
     0, 18000, 11000, 15000,  2000,  4000, 20000,
  4000,     0,  6000,  5000, 19000, 15000,     0,
 15000, 10000,     0,  7000,     0,  7000,  5000,
 14000,  5000,  3000,     0, 10000, 15000, 19000,
  2000, 11000,  1000, 10000,     0, 14000,  6000,
 10000, 14000,  6000,  5000,  3000,     0, 18000,
  8000,  1000, 11000,  8000,  6000, 20000,     0
]);

% Safe upper bound on total flow
int: maxTotalFlow = sum(j in CITIES where j != source)(cap[source, j]);

% Decision variables: flow on each directed arc
array[CITIES, CITIES] of var 0..maxTotalFlow: flow;
var 0..maxTotalFlow: totalFlow;

% Capacity constraints (cap=0 forces flow=0)
constraint forall(i in CITIES, j in CITIES) (flow[i, j] <= cap[i, j]);

% No self-loops
constraint forall(i in CITIES) (flow[i, i] = 0);

% Flow conservation for intermediate cities
constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(i in CITIES)(flow[i, k]) = sum(j in CITIES)(flow[k, j])
  );

% Disallow inflow to source and outflow from sink for clean max-flow
constraint sum(i in CITIES)(flow[i, source]) = 0;
constraint sum(j in CITIES)(flow[sink, j]) = 0;

% Define total flow as outflow from source (equivalently inflow to sink)
constraint totalFlow = sum(j in CITIES)(flow[source, j]);
constraint totalFlow = sum(i in CITIES)(flow[i, sink]);

solve maximize totalFlow;