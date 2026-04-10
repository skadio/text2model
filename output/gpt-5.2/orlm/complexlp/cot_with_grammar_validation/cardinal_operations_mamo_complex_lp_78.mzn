include "globals.mzn";

int: n = 6;
set of int: LOC = 1..n;

array[LOC, LOC] of int: cost =
  [|  0, 77, 89, 19, 31, 62
   | 77,  0, 36, 81, 71, 93
   | 89, 36,  0, 32, 48, 36
   | 19, 81, 32,  0, 98, 82
   | 31, 71, 48, 98,  0, 66
   | 62, 93, 36, 82, 66,  0 |];

int: start = 1;

array[LOC] of var LOC: succ;
array[LOC] of var 0..n-1: ord;
var int: total_cost;

constraint all_different(succ);
constraint forall(i in LOC)(succ[i] != i);

constraint ord[start] = 0;
constraint forall(i in LOC where i != start)(ord[i] >= 1 /\ ord[i] <= n - 1);

constraint forall(i in LOC where i != start)(
  forall(j in LOC where j != start /\ j != i)(
    ord[i] - ord[j] + n * bool2int(succ[i] == j) <= n - 1
  )
);

constraint total_cost = sum(i in LOC)(cost[i, succ[i]]);

solve minimize total_cost;

output ["minimum_total_cost=", show(total_cost), "\n",
        "succ=", show(succ), "\n"];