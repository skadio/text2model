int: num_centers = 5;
int: num_stores = 5;

set of int: CENTERS = 1..num_centers;
set of int: STORES = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000];
array[CENTERS] of int: capacity = [1954, 1446, 820, 1640, 966];

array[STORES] of int: demand = [589, 962, 966, 643, 904];

array[CENTERS, STORES] of int: trans_cost =
  array2d(CENTERS, STORES,
    [ 5, 2, 3, 3, 3,
      5, 4, 3, 5, 2,
      4, 2, 4, 5, 1,
      4, 2, 5, 4, 1,
      1, 3, 3, 2, 4
    ]);

int: total_demand = sum(s in STORES)(demand[s]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var int: ship;

constraint forall(c in CENTERS, s in STORES) (
  ship[c,s] >= 0 /\ ship[c,s] <= total_demand
);

constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: total_cost =
  sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(trans_cost[c,s] * ship[c,s]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship =\n",
  show([ [ ship[c,s] | s in STORES ] | c in CENTERS ]), "\n"
];