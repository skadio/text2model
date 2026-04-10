% Facility location + transportation (capacitated) for MarketFlow Inc.

int: M = 4;
int: N = 6;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000];

array[DC, ST] of int: trans_cost =
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[ST] of int: demand = [910, 875, 589, 962, 966, 643];
array[DC] of int: capacity = [1631, 1954, 1446, 820];

int: total_demand = sum(i in ST)(demand[i]);
int: max_trans_cost = max([trans_cost[j,i] | j in DC, i in ST]);
int: max_total_cost = sum(j in DC)(open_cost[j]) + total_demand * max_trans_cost;

array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

var 0..max_total_cost: total_cost;

constraint forall(i in ST) (
  sum(j in DC)(ship[j,i]) = demand[i]
);

constraint forall(j in DC) (
  sum(i in ST)(ship[j,i]) <= capacity[j] * bool2int(open[j])
);

constraint total_cost =
  sum(j in DC)(open_cost[j] * bool2int(open[j])) +
  sum(j in DC, i in ST)(trans_cost[j,i] * ship[j,i]);

solve
  minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show([bool2int(open[j]) | j in DC]), "\n",
  "ship =\n",
  concat([
    concat([ "  ", show(ship[j,i]), if i == N then "\n" else "" endif
           | i in ST ])
    | j in DC
  ])
];