include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 83, 30, 38, 90, 72
   | 65,  0, 93, 13, 41, 55
   | 12, 39,  0, 85, 17, 66
   | 44, 26, 58,  0, 73, 24
   | 87, 42, 69, 31,  0, 80
   | 21, 64, 33, 57, 48,  0
   |];

% Variables
array[CITIES] of var CITIES: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];