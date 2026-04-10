include "globals.mzn";

int: n = 4;
set of int: N = 1..n;

array[N, N] of int: cost =
  [|  0, 62, 51, 50
   | 62,  0, 42, 69
   | 51, 42,  0, 11
   | 50, 69, 11,  0 |];

array[N] of var N: succ;
var int: total_cost;

constraint forall(i in N)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in N)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];