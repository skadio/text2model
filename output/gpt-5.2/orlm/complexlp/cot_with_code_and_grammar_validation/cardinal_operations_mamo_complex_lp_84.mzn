include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES, [
    0, 23, 50, 92, 56, 91,
    23, 0, 38, 25, 25, 69,
    50, 38, 0, 66, 51, 76,
    92, 25, 66, 0, 97, 37,
    56, 25, 51, 97, 0, 30,
    91, 69, 76, 37, 30, 0
  ]);

% Variables
array[CITIES] of var CITIES: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

% Optional output
output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];