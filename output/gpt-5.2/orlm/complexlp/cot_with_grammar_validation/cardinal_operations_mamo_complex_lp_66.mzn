include "globals.mzn";

int: n = 6;
set of int: LOC = 1..n;

array[LOC, LOC] of int: cost =
  array2d(LOC, LOC,
  [  0, 48, 23, 70, 14, 20,
    48,  0, 79, 37, 63, 96,
    23, 79,  0, 40, 66, 68,
    70, 37, 40,  0, 70, 28,
    14, 63, 66, 70,  0, 73,
    20, 96, 68, 28, 73,  0 ]);

int: cost_max = 96;

array[LOC] of var LOC: succ;
array[LOC] of var 0..n-1: order;
var 0..n * cost_max: total_cost;

constraint forall(i in LOC)(succ[i] != i);

constraint all_different(succ);

constraint order[1] = 0;
constraint forall(i in 2..n)(order[i] >= 1 /\ order[i] <= n-1);

constraint
  forall(i in 2..n, j in 2..n where i != j)(
    order[i] - order[j] + n * bool2int(succ[i] = j) <= n - 1
  );

constraint total_cost = sum(i in LOC)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];