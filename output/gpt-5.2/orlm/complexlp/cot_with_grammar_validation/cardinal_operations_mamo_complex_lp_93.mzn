include "globals.mzn";

int: N = 4;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
  [| 0, 61, 65, 63
   | 61, 0, 94, 31
   | 65, 94, 0, 19
   | 63, 31, 19, 0
  |];

array[Cities] of var Cities: succ;
var int: total_cost;

constraint forall(i in Cities)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];