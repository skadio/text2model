include "globals.mzn";

% Parameters
int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
  [
    0, 58, 15, 75, 91,
    58, 0, 54, 85, 11,
    15, 54, 0, 28, 61,
    75, 85, 28, 0, 47,
    91, 11, 61, 47, 0
  ]);

int: maxArcCost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: UB = N * maxArcCost;

% Variables
array[CITIES] of var CITIES: succ;   % successor city for each city in the tour
var 0..UB: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output ["total_cost = ", show(total_cost), "\n",
        "succ = ", show(succ), "\n"];