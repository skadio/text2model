include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 86, 81, 64, 65, 24
 | 86,  0, 44, 80, 91, 23
 | 81, 44,  0, 15, 25, 89
 | 64, 80, 15,  0, 89, 41
 | 65, 91, 25, 89,  0, 29
 | 24, 23, 89, 41, 29,  0 |];

% Successor representation of a Hamiltonian cycle
array[CITIES] of var CITIES: succ;
constraint forall(i in CITIES)(succ[i] != i);

% Ensure a single tour visiting each city exactly once
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "minimum_total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];