include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[| 0, 26, 49, 75
 | 26, 0, 19, 52
 | 49, 19, 0, 49
 | 75, 52, 49, 0
 |];

int: start = 1;

array[CITIES] of var CITIES: succ;
array[CITIES] of var 0..1: x;
var 0..1000000: total_cost;

constraint forall(i in CITIES)(x[i] = 1);

constraint all_different(succ);

constraint forall(i in CITIES)(succ[i] != i);

constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output ["total_cost = ", show(total_cost), "\n", "succ = ", show(succ), "\n"];