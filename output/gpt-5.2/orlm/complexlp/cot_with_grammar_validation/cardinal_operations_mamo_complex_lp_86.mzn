include "globals.mzn";

int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 73, 39, 79, 38
   | 73,  0, 30, 46, 29
   | 39, 30,  0, 88, 57
   | 79, 46, 88,  0, 59
   | 38, 29, 57, 59,  0
  |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: UB = N * maxCost;

array[CITIES] of var CITIES: succ;
var 0..UB: total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];