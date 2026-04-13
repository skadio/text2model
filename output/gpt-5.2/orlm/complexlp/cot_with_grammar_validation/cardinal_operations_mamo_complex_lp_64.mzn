include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 65, 41, 14, 16, 35
   | 65, 0, 76, 52, 89, 45
   | 41, 76, 0, 72, 38, 62
   | 14, 52, 72, 0, 22, 24
   | 16, 89, 38, 22, 0, 89
   | 35, 45, 62, 24, 89, 0
   |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;

var 0..sum(i in CITIES, j in CITIES)(cost[i, j]): total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint circuit(succ);
constraint inverse(succ, pred);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];