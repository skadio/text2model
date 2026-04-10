int: NDC = 5;
int: NSTORE = 9;

set of int: DC = 1..NDC;
set of int: STORE = 1..NSTORE;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000];
array[DC] of int: capacity  = [1825, 1821, 1365, 1929, 1502];
array[STORE] of int: demand  = [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[DC, STORE] of int: ship_cost =
[|
  5, 2, 3, 3, 3, 5, 4, 3, 5 |
  2, 4, 2, 4, 5, 1, 4, 2, 5 |
  4, 1, 1, 3, 3, 2, 4, 4, 3 |
  4, 4, 1, 3, 5, 3, 5, 1, 2 |
  4, 1, 4, 2, 2, 1, 2, 5, 2
|];

int: total_demand = sum(s in STORE)(demand[s]);
int: max_cap = max(d in DC)(capacity[d]);
int: max_ship = max(d in DC, s in STORE)(ship_cost[d,s]);
int: upper_cost = sum(d in DC)(open_cost[d]) + max_ship * total_demand;

array[DC] of var bool: open;
array[DC, STORE] of var 0..max_cap: x;

var 0..upper_cost: total_cost;

constraint forall(s in STORE)(
  sum(d in DC)(x[d,s]) = demand[s]
);

constraint forall(d in DC)(
  sum(s in STORE)(x[d,s]) <= capacity[d] * bool2int(open[d])
);

constraint total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in STORE)(ship_cost[d,s] * x[d,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n"
];