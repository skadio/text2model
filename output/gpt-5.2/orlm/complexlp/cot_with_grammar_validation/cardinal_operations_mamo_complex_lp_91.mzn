include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 95, 36, 93, 16
   | 95,  0, 95, 29, 96
   | 36, 95,  0, 72, 38
   | 93, 29, 72,  0, 77
   | 16, 96, 38, 77,  0
  |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;
var int: total_cost;

constraint circuit(succ);
constraint inverse(succ, pred);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [show(total_cost), "\n"];