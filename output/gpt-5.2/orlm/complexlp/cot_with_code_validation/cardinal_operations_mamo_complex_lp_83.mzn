include "globals.mzn";

% Parameters
int: n = 5;
set of int: N = 1..n;

array[N, N] of int: cost =
  [|  0, 13, 87, 76, 50
   | 13,  0, 15, 65, 85
   | 87, 15,  0, 45, 81
   | 76, 65, 45,  0, 80
   | 50, 85, 81, 80,  0 |];

% Variables
array[N] of var N: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in N)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];