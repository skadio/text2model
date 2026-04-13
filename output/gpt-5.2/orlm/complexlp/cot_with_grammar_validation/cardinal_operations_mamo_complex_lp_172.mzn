int: M = 8;
int: N = 9;

set of int: CENTERS = 1..M;
set of int: STORES  = 1..N;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: trans_cost =
[|
  2, 3, 4, 5, 2, 3, 4, 5, 2,
  1, 2, 3, 4, 5, 1, 2, 3, 4,
  1, 2, 3, 4, 1, 2, 3, 4, 1,
  1, 3, 5, 2, 4, 1, 3, 5, 2,
  2, 1, 4, 3, 5, 2, 1, 4, 3,
  3, 2, 1, 5, 4, 3, 2, 1, 5,
  2, 4, 3, 5, 2, 4, 3, 5, 2,
  1, 5, 2, 4, 3, 1, 5, 2, 4
|];

array[STORES] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];
array[CENTERS] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: total_demand = sum(j in STORES)(demand[j]);

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: ship;

constraint forall(j in STORES) (
  sum(i in CENTERS)(ship[i,j]) = demand[j]
);

constraint forall(i in CENTERS) (
  sum(j in STORES)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

var int: total_cost =
  sum(i in CENTERS)(open_cost[i] * bool2int(open[i])) +
  sum(i in CENTERS, j in STORES)(trans_cost[i,j] * ship[i,j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n",
  "ship=\n", show(ship), "\n"
];