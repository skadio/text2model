int: num_centers = 6;
int: num_stores = 8;

set of int: CENTERS = 1..num_centers;
set of int: STORES = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];
array[CENTERS] of int: capacity  = [1365, 1929, 1502, 1201, 1529, 961];

array[STORES] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS, STORES] of int: ship_cost =
[|
  2, 3, 3, 3, 5, 4, 3, 5 |
  2, 4, 2, 4, 5, 1, 4, 2 |
  5, 4, 1, 1, 3, 3, 2, 4 |
  4, 3, 4, 4, 1, 3, 5, 3 |
  5, 1, 2, 4, 1, 4, 2, 2 |
  1, 2, 5, 2, 4, 4, 4, 4
|];

int: max_cap = max(c in CENTERS)(capacity[c]);

array[CENTERS] of var 0..1: open;
array[CENTERS, STORES] of var 0..max_cap: x;

var int: total_cost;

constraint
  forall(s in STORES)(
    sum(c in CENTERS)(x[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS)(
    sum(s in STORES)(x[c,s]) <= capacity[c] * open[c]
  );

constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * open[c]) +
    sum(c in CENTERS, s in STORES)(ship_cost[c,s] * x[c,s]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show(open), "\n"
];