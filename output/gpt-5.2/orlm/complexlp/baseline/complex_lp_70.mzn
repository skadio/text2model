include "globals.mzn";

int: n = 4;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
[|  0, 61, 17, 81
 | 61,  0, 40, 52
 | 17, 40,  0, 23
 | 81, 52, 23,  0 |];

array[Cities] of var Cities: succ;
array[Cities] of var Cities: pred;

constraint
  forall(i in Cities) (succ[i] != i) /\
  forall(i in Cities) (pred[i] != i) /\
  forall(i in Cities) (pred[succ[i]] = i) /\
  forall(i in Cities) (succ[pred[i]] = i) /\
  circuit(succ);

var int: total_cost = sum(i in Cities)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (i -> succ[i]):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in Cities ])
];