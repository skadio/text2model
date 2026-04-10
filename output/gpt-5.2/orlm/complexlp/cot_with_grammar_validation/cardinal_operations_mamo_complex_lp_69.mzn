include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 83, 30, 38, 72, 52
 | 19,  0, 93, 13,  7, 28
 | 44, 71,  0, 85, 17, 49
 | 61, 12, 24,  0, 66, 31
 | 87, 42, 65, 18,  0, 54
 | 26, 79, 11, 57, 33,  0
 |];

array[CITIES] of var CITIES: succ;
var int: total_cost;

constraint forall(i in CITIES) (succ[i] != i);
constraint circuit(succ);
constraint total_cost = sum(i in CITIES) (cost[i, succ[i]]);

solve minimize total_cost;

output [
  "minimum_total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];