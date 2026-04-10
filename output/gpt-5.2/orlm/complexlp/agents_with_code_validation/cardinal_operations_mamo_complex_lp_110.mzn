% Max flow from source (0) to sink (5) in a directed capacitated network

int: nCities = 6;
set of int: CITIES = 0..nCities-1;

int: source = 0;
int: sink   = 5;

% Capacity matrix (0 => no arc). Use array2d to enforce index set 0..5 x 0..5.
array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES,
    [
      0,  6,  8,  1,  9,  8,
     16,  0,  6,  0, 12, 16,
      7, 16,  0, 20, 17,  9,
      3, 11, 14,  0,  7,  0,
      6, 19, 19,  3,  0, 20,
     20,  5, 16, 12,  2,  0
    ]
  );

int: maxCap = max([cap[i,j] | i in CITIES, j in CITIES]);

array[CITIES, CITIES] of var 0..maxCap: flow;

var 0..sum(j in CITIES)(cap[source,j]): totalFlow;

% Capacity constraints (also forces flow to 0 when cap=0 due to upper bound)
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

% Define totalFlow as net outflow from source
constraint totalFlow =
  sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Ensure sink net inflow equals totalFlow
constraint totalFlow =
  sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);

solve maximize totalFlow;