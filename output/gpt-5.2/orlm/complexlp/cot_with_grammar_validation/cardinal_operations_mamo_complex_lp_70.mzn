include "globals.mzn";

int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 61, 17, 81
   | 61, 0, 40, 52
   | 17, 40, 0, 23
   | 81, 52, 23, 0 |];

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