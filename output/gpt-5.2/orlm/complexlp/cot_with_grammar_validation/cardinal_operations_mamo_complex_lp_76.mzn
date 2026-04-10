include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 31, 19, 71, 74
   | 31,  0, 39, 77, 84
   | 19, 39,  0, 65, 78
   | 71, 77, 65,  0, 38
   | 74, 84, 78, 38,  0 |];

array[CITIES] of var CITIES: succ;
var 0..10000: total_cost;

constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];