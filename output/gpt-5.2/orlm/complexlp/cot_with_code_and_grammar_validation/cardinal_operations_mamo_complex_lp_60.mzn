include "globals.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n; % 1=A, 2=B, 3=C, 4=D

array[CITIES, CITIES] of int: cost =
  [| 0, 19, 45, 30
   | 19, 0, 89, 46
   | 45, 89, 0, 11
   | 30, 46, 11, 0 |];

% Variables: successor of each city in the tour
array[CITIES] of var CITIES: succ;

% Constraints: one Hamiltonian cycle visiting each city exactly once
constraint circuit(succ);

% Objective: minimize total travel cost
solve minimize sum(i in CITIES)(cost[i, succ[i]]);

output [
  "Minimum cost = ", show(sum(i in CITIES)(cost[i, succ[i]])), "\n",
  "succ = ", show(succ), "\n"
];