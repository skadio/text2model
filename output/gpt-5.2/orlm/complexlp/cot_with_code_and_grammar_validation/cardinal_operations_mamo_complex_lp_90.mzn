include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
 [| 0, 64, 78, 23, 15
  | 64, 0, 15, 44, 93
  | 78, 15, 0, 53, 57
  | 23, 44, 53, 0, 56
  | 15, 93, 57, 56, 0 |];

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