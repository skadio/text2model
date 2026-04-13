int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 46, 63, 54, 45
 | 46,  0, 48, 50, 51
 | 63, 48,  0, 31, 64
 | 54, 50, 31,  0, 94
 | 45, 51, 64, 94,  0 |];

array[CITIES] of var CITIES: succ;

constraint
  forall(i in CITIES)(succ[i] != i);

% Single Hamiltonian cycle (tour can start at any city)
include "globals.mzn";
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor array (tour edges i -> succ[i]): ", show(succ), "\n"
];