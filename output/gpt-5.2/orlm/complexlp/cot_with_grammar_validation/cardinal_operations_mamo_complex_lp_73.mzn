include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[| 0,  37, 72, 66, 33
 | 37, 0,  26, 56, 100
 | 72, 26, 0,  49, 32
 | 66, 56, 49, 0,  13
 | 33, 100,32, 13, 0  |];

int: max_cost = 100;
int: UB = n * max_cost;

array[CITIES] of var CITIES: succ;
var 0..UB: total_cost;

constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];