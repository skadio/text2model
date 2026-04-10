int: F = 7;
int: S = 9;

set of int: DC = 1..F;
set of int: STORES = 1..S;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[DC, STORES] of int: trans_cost =
  [| 1, 2, 3, 4, 5, 1, 2, 3, 4
   | 2, 3, 4, 5, 1, 2, 3, 4, 5
   | 3, 4, 5, 1, 2, 3, 4, 5, 1
   | 4, 5, 1, 2, 3, 4, 5, 1, 2
   | 5, 1, 2, 3, 4, 5, 1, 2, 3
   | 1, 3, 5, 2, 4, 1, 3, 5, 2
   | 2, 4, 1, 3, 5, 2, 4, 1, 3
  |];

array[STORES] of int: demand = [440, 512, 578, 610, 655, 701, 745, 820, 892];

array[DC] of int: capacity = [814, 950, 1200, 1350, 1500, 1700, 1962];

int: total_demand = sum(i in STORES)(demand[i]);

array[DC] of var bool: open;
array[DC, STORES] of var 0..total_demand: ship;

constraint forall(i in STORES) (
  sum(f in DC)(ship[f, i]) = demand[i]
);

constraint forall(f in DC) (
  sum(i in STORES)(ship[f, i]) <= capacity[f] * bool2int(open[f])
);

var int: total_cost =
  sum(f in DC)(open_cost[f] * bool2int(open[f])) +
  sum(f in DC, i in STORES)(trans_cost[f, i] * ship[f, i]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[f]) | f in DC]), "\n"
];