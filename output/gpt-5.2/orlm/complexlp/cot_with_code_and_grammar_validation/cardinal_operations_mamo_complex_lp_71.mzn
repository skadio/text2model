include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 49, 34, 18, 62, 14
   | 49,  0, 35, 24, 57, 17
   | 34, 35,  0, 20, 34, 58
   | 18, 24, 20,  0, 47, 45
   | 62, 57, 34, 47,  0, 71
   | 14, 17, 58, 45, 71,  0 |];

% Decision variables: successor city for each city (Hamiltonian cycle)
array[CITIES] of var CITIES: succ;

% Total travel cost
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