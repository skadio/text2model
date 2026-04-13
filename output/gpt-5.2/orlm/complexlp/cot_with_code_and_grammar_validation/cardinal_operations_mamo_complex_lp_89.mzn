include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 82, 76, 92, 59
   | 82, 0, 98, 58, 82
   | 76, 98, 0, 26, 74
   | 92, 58, 26, 0, 96
   | 59, 82, 74, 96, 0 |];

% Variables
array[CITIES] of var CITIES: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint forall(i in CITIES)(succ[i] != i);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];