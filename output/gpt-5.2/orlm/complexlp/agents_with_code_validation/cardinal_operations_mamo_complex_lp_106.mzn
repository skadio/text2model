% Maximum flow in a directed network (cities 0..8)

% Parameters
int: nCities = 9;
set of int: CITIES = 0..nCities-1;
int: source = 0;
int: sink = 8;

% capacity (tons) on directed arc i->j (0 means no arc)
array[CITIES, CITIES] of int: cap =
  array2d(CITIES, CITIES, [
    0, 15, 12,  9,  7, 12,  5, 20, 10,
    6,  0,  8,  0, 19, 14, 17,  9, 16,
   19, 11,  0,  0, 13, 14, 17, 10, 13,
   15,  4,  5,  0,  2, 18,  6, 17, 19,
    2,  8,  2,  4,  0,  6, 14, 20, 18,
   14,  9, 18,  7,  4,  0, 11, 11, 13,
   12, 14, 12,  4, 18,  6,  0,  5,  4,
   20,  1,  6, 17,  4,  2, 11,  0,  9,
   16,  6, 14,  0, 17, 17,  6,  9,  0
  ]);

% Trivial upper bound on max flow (total outbound capacity from the source)
int: totalCapOutSource = sum(j in CITIES)(cap[source, j]);

% Variables
array[CITIES, CITIES] of var 0..totalCapOutSource: flow;
var 0..totalCapOutSource: maxFlow;

% Constraints

% Capacity constraints (if cap[i,j]=0 then flow[i,j]=0 automatically)
constraint forall(i in CITIES, j in CITIES) (
  flow[i, j] <= cap[i, j]
);

% Flow conservation for intermediate cities
constraint forall(k in CITIES where k != source /\ k != sink) (
  sum(i in CITIES)(flow[i, k]) = sum(j in CITIES)(flow[k, j])
);

% Define maxFlow as net flow out of source and into sink
constraint maxFlow =
  sum(j in CITIES)(flow[source, j]) - sum(i in CITIES)(flow[i, source]);

constraint maxFlow =
  sum(i in CITIES)(flow[i, sink]) - sum(j in CITIES)(flow[sink, j]);

% Objective
solve maximize maxFlow;

output ["Maximum goods transported (tons) = ", show(maxFlow), "\n"];