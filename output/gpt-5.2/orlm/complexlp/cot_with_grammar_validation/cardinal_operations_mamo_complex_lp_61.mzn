include "globals.mzn";

int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 17, 52, 79
   | 17, 0, 15, 71
   | 52, 15, 0, 54
   | 79, 71, 54, 0
  |];

array[CITIES] of var CITIES: succ;
var int: total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];