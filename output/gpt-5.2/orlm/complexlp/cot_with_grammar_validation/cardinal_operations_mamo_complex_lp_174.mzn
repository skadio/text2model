int: num_centers = 8;
int: num_stores = 5;

set of int: CENTERS = 1..num_centers;
set of int: STORES = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: transp_cost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2 |];

array[STORES] of int: demand = [964, 739, 491, 766, 854];
array[CENTERS] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: max_cap = max([capacity[c] | c in CENTERS]);
int: max_ship = max_cap;

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..max_ship: ship;

var int: total_cost;

constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c, s]) = demand[s]
);

constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

constraint forall(c in CENTERS, s in STORES) (
  ship[c, s] <= capacity[c] * bool2int(open[c])
);

constraint total_cost =
  sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transp_cost[c, s] * ship[c, s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship=\n",
  show(ship), "\n"
];