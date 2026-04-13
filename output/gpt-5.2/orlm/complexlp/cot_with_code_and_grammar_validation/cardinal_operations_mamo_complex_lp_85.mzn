include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 63, 62, 49, 58, 38
 | 63,  0, 93, 21, 66, 42
 | 62, 93,  0, 26, 99, 96
 | 49, 21, 26,  0, 73, 80
 | 58, 66, 99, 73,  0, 76
 | 38, 42, 96, 80, 76,  0 |];

% Decision variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
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