include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 29, 97, 72
   | 29, 0, 69, 52
   | 97, 69, 0, 91
   | 72, 52, 91, 0 |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;

var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint inverse(pred, succ);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];