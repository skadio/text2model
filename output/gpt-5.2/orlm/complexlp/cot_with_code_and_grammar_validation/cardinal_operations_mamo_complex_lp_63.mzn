include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 28, 89, 59, 41
   | 28,  0, 85, 12, 68
   | 89, 85,  0, 22, 70
   | 59, 12, 22,  0, 48
   | 41, 68, 70, 48,  0 |];

% Variables
array[CITIES] of var CITIES: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];