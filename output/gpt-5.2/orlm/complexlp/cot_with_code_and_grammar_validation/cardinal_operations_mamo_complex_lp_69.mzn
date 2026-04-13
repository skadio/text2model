include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 83, 30, 38, 87, 56
 | 12,  0, 93, 13, 44, 67
 | 45, 19,  0, 85, 17, 62
 | 29, 54, 71,  0, 33, 26
 | 87, 42, 58, 39,  0, 48
 | 34, 76, 21, 90, 11,  0 |];

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