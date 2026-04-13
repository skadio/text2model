include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: Cities = 1..nCities;

array[Cities, Cities] of int: cost =
  [|  0, 76, 17, 24
   | 76,  0, 84, 11
   | 17, 84,  0, 90
   | 24, 11, 90,  0 |];

% Variables
array[Cities] of var Cities: succ;  % succ[i] = next city visited after i
var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];