include "globals.mzn";

int: N = 5;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
  [| 0, 28, 89, 59, 41
   | 28, 0, 85, 12, 68
   | 89, 85, 0, 22, 70
   | 59, 12, 22, 0, 48
   | 41, 68, 70, 48, 0 |];

array[Cities] of var Cities: next;
var 0..sum(i in Cities, j in Cities)(cost[i,j]): total_cost;

constraint forall(i in Cities)(next[i] != i);
constraint circuit(next);

constraint total_cost = sum(i in Cities)(cost[i, next[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "next = ", show(next), "\n"
];