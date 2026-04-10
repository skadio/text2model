include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

% Cost matrix (0 on diagonal)
array[CITIES, CITIES] of int: cost =
  [|  0, 44, 19, 92, 71
   | 44,  0, 22, 84, 63
   | 19, 22,  0, 47, 89
   | 92, 84, 47,  0, 78
   | 71, 63, 89, 78,  0 |];

% Variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
var int: total_cost;

% Constraints: one Hamiltonian circuit visiting each city exactly once
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];