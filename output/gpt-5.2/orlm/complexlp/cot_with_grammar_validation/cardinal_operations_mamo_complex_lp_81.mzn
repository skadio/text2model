include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 35, 90, 23, 62
   | 35,  0, 53, 58, 46
   | 90, 53,  0, 28, 91
   | 23, 58, 28,  0, 77
   | 62, 46, 91, 77,  0
  |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;
var int: total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint all_different(succ);
constraint all_different(pred);

constraint inverse(succ, pred);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];