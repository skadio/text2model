int: M = 4;
int: N = 8;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000];

array[DC, ST] of int: trans_cost =
  [| 5, 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4, 4, 1, 3 |];

array[ST] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[DC] of int: capacity = [1041, 1576, 1364, 1697];

int: max_cap = max([capacity[i] | i in DC]);

array[DC] of var 0..1: open;
array[DC, ST] of var 0..max_cap: ship;

constraint forall(j in ST) (
  sum(i in DC)(ship[i, j]) = demand[j]
);

constraint forall(i in DC) (
  sum(j in ST)(ship[i, j]) <= capacity[i] * open[i]
);

constraint forall(i in DC, j in ST) (
  ship[i, j] <= demand[j]
);

var int: total_cost =
  sum(i in DC)(open_cost[i] * open[i]) +
  sum(i in DC, j in ST)(trans_cost[i, j] * ship[i, j]);

solve minimize total_cost;

output ["total_cost = ", show(total_cost), "\n"];