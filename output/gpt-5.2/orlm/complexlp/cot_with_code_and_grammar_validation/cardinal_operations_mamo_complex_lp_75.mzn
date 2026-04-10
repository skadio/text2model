include "globals.mzn";

% Parameters
int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 87, 41, 55, 57
   | 87,  0, 80, 33, 40
   | 41, 80,  0, 90, 42
   | 55, 33, 90,  0, 53
   | 57, 40, 42, 53,  0 |];

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