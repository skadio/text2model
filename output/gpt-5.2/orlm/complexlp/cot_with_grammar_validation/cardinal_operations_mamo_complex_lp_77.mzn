include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
    [  0, 27, 48, 76,
      27,  0, 82, 88,
      48, 82,  0, 97,
      76, 88, 97,  0 ]);

array[CITIES] of var CITIES: succ;
var 0..sum(i,j in CITIES where i != j)(cost[i,j]): total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];