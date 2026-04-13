include "globals.mzn";

int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 58, 15, 75, 91
   | 58,  0, 54, 85, 11
   | 15, 54,  0, 28, 61
   | 75, 85, 28,  0, 47
   | 91, 11, 61, 47,  0 |];

array[CITIES] of var CITIES: succ;
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

constraint circuit(succ);
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];