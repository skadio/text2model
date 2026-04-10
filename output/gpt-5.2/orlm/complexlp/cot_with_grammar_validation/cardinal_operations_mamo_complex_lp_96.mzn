include "globals.mzn";

int: N = 6;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
[| 0, 21, 43, 25, 38, 91
 | 21, 0, 32, 25, 16, 14
 | 43, 32, 0, 96, 71, 98
 | 25, 25, 96, 0, 53, 22
 | 38, 16, 71, 53, 0, 100
 | 91, 14, 98, 22, 100, 0
 |];

int: minCost = min([cost[i,j] | i in CITIES, j in CITIES where i != j]);
int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES where i != j]);

array[CITIES] of var CITIES: succ;
array[CITIES] of var 0..N-1: pos;
var (N * minCost)..(N * maxCost): total_cost;

constraint all_different(succ);
constraint circuit(succ);

constraint pos[1] = 0;
constraint forall(i in CITIES) (succ[i] != i);
constraint forall(i in CITIES) (pos[succ[i]] = (pos[i] + 1) mod N);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];