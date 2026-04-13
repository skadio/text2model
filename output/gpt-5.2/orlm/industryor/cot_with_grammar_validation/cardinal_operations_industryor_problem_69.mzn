include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: dist =
  [| 0, 10, 20, 12
   | 10, 0,  5, 10
   | 20, 5,  0,  8
   | 15, 12, 8,  0 |];

array[CITIES] of var CITIES: succ;
var 0..sum(i in CITIES, j in CITIES)(dist[i,j]): total_dist;

constraint circuit(succ);
constraint total_dist = sum(i in CITIES)(dist[i, succ[i]]);

solve minimize total_dist;

output [
  "total_dist = ", show(total_dist), "\n",
  "succ = ", show(succ), "\n"
];