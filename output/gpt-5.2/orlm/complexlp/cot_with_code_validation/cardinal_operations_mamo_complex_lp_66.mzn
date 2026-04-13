include "globals.mzn";

% Parameters
int: n = 6;
set of int: LOC = 1..n;

array[LOC, LOC] of int: cost =
  [| 0, 48, 23, 70, 14, 20
   | 48, 0, 79, 37, 63, 96
   | 23, 79, 0, 40, 66, 68
   | 70, 37, 40, 0, 70, 28
   | 14, 63, 66, 70, 0, 73
   | 20, 96, 68, 28, 73, 0 |];

% Variables
array[LOC] of var LOC: succ;  % successor of each location in the tour
var int: total_cost;

% Constraints: single Hamiltonian circuit
constraint circuit(succ);

% Total cost
constraint total_cost = sum(i in LOC)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];