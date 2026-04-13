include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
  [ 0, 87, 41, 55, 57,
    87, 0, 80, 33, 40,
    41, 80, 0, 90, 42,
    55, 33, 90, 0, 53,
    57, 40, 42, 53, 0 ]);

int: max_cost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: upper_bound = n * max_cost;

array[CITIES] of var CITIES: succ;
var 0..upper_bound: total_cost;

constraint circuit(succ);
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "minimum_total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];