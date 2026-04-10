include "globals.mzn";

int: n = 4;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
  array2d(Cities, Cities, [
    0, 94, 34, 87,
    94, 0, 62, 87,
    34, 62, 0, 97,
    87, 87, 97, 0
  ]);

int: max_cost = max([cost[i,j] | i in Cities, j in Cities]);
int: ub = n * max_cost;

array[Cities] of var Cities: succ;
var 0..ub: total_cost;

constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];