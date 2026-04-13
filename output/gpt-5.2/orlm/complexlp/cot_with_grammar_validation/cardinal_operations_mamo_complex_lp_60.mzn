include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 19, 45, 30
   | 19, 0, 89, 46
   | 45, 89, 0, 11
   | 30, 46, 11, 0 |];

array[CITIES] of var CITIES: succ;
var int: total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];