include "globals.mzn";

% Parameters
int: n = 4;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
  [| 0, 94, 34, 87
   | 94, 0, 62, 87
   | 34, 62, 0, 97
   | 87, 87, 97, 0 |];

% Variables
array[Cities] of var Cities: succ;

% Constraints
constraint circuit(succ);

% Objective
var int: total_cost = sum(i in Cities)(cost[i, succ[i]]);
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];