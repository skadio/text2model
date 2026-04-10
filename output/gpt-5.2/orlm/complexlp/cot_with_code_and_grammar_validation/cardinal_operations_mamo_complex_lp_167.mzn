int: M = 5;
int: N = 9;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000];

array[DC, ST] of int: trans_cost =
[| 5, 2, 3, 3, 3, 5, 4, 3, 5
 | 2, 4, 2, 4, 5, 1, 4, 2, 5
 | 4, 1, 1, 3, 3, 2, 4, 4, 3
 | 4, 4, 1, 3, 5, 3, 5, 1, 2
 | 4, 1, 4, 2, 2, 1, 2, 5, 2
 |];

array[ST] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];
array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502];

int: total_demand = sum(s in ST)(demand[s]);
int: max_open_cost_sum = sum(d in DC)(open_cost[d]);
int: max_trans_cost = max([trans_cost[d,s] | d in DC, s in ST]);

array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

var 0..(max_open_cost_sum + total_demand * max_trans_cost): total_cost;

constraint forall(d in DC, s in ST) (
  ship[d,s] <= demand[s]
);

constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

constraint total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(trans_cost[d,s] * ship[d,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n"
];