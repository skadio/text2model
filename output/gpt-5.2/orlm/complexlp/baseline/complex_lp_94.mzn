include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 94, 34, 87
   | 94, 0, 62, 87
   | 34, 62, 0, 97
   | 87, 87, 97, 0 |];

% successor representation of a Hamiltonian cycle
array[CITIES] of var CITIES: succ;
constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor array (city -> next city): ", show(succ), "\n"
];