include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
 [|  0, 31, 19, 71, 74
  | 31,  0, 39, 77, 84
  | 19, 39,  0, 65, 78
  | 71, 77, 65,  0, 38
  | 74, 84, 78, 38,  0
  |];

% Variables
array[CITIES] of var CITIES: succ;
var 0..sum(i in CITIES, j in CITIES where i != j)(cost[i,j]): total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];