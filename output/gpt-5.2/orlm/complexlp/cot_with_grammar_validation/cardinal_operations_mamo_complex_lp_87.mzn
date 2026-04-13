include "globals.mzn";

int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 46, 63, 54, 45
   | 46, 0, 48, 50, 51
   | 63, 48, 0, 31, 64
   | 54, 50, 31, 0, 94
   | 45, 51, 64, 94, 0 |];

array[CITIES] of var CITIES: next;
var int: total_cost;

constraint forall(i in CITIES) (next[i] != i);
constraint circuit(next);

constraint total_cost = sum(i in CITIES)(cost[i, next[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "next = ", show(next), "\n"
];