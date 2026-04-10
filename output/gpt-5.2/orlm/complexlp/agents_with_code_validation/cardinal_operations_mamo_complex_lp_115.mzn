% Maximum flow from City 0 to City 6

int: nCities = 7;
set of int: CITIES = 0..nCities-1;

int: source = 0;
int: sink   = 6;

% Capacity matrix (thousand kg/day). 0 means no direct arc.
array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES,
    [  0, 20, 19, 18,  0, 11,  2,
      18,  0, 15, 10,  0,  9,  0,
      18,  4,  0, 11, 15,  0, 13,
      17,  3, 15,  0,  2,  4,  4,
       2, 11, 17, 17,  0,  2, 17,
      12,  4, 16, 13,  5,  0,  3,
       7,  9, 17, 18, 16,  8,  0
    ]
  );

% Safe upper bound on total s->t flow: sum of capacities leaving the source
int: maxTotalFlow = sum(j in CITIES)(cap[source, j]);

% Flow on each directed arc (thousand kg/day)
array[CITIES, CITIES] of var 0..maxTotalFlow: flow;

% Total flow sent from source (equals total received at sink with conservation)
var 0..maxTotalFlow: totalFlow;

% Capacity constraints (cap=0 forces flow=0)
constraint forall(i in CITIES, j in CITIES) (
  flow[i,j] <= cap[i,j]
);

% Flow conservation at intermediate cities
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
);

% Define totalFlow as net outflow from the source
constraint totalFlow =
  sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

solve maximize totalFlow;

output [
  "Max flow (thousand kg/day) = ", show(totalFlow), "\n"
];