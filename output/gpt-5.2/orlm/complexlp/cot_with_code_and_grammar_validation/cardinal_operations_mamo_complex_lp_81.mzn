include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 35, 90, 23, 62
   | 35, 0, 53, 58, 46
   | 90, 53, 0, 28, 91
   | 23, 58, 28, 0, 77
   | 62, 46, 91, 77, 0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city from each city
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