int: num_centers = 4;
int: num_stores = 6;

set of int: CENTERS = 1..num_centers;
set of int: STORES = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: ship_cost = [|
  5, 5, 2, 3, 3, 3 |
  5, 4, 3, 5, 2, 4 |
  2, 4, 5, 1, 4, 2 |
  5, 4, 1, 1, 3, 3
|];

array[STORES] of int: demand = [910, 875, 589, 962, 966, 643];
array[CENTERS] of int: capacity = [1631, 1954, 1446, 820];

int: total_demand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: x;

var int: total_cost;

constraint
  forall(s in STORES) (
    sum(c in CENTERS)(x[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS) (
    sum(s in STORES)(x[c,s]) <= capacity[c] * bool2int(open[c])
  );

constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(ship_cost[c,s] * x[c,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "x=\n", show([ [x[c,s] | s in STORES] | c in CENTERS ]), "\n"
];