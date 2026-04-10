int: N = 9;
int: M = 7;

set of int: CENTERS = 1..N;
set of int: STORES = 1..M;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];
array[STORES] of int: demand = [695, 737, 452, 616, 587, 779, 892];
array[CENTERS] of int: capacity = [1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

array[CENTERS, STORES] of int: trans_cost =
[|
  3, 5, 6, 4, 7, 8, 6 |
  2, 4, 5, 3, 6, 7, 5 |
  6, 7, 4, 5, 3, 6, 4 |
  5, 6, 7, 4, 6, 5, 7 |
  4, 5, 6, 3, 5, 6, 4 |
  3, 4, 5, 2, 4, 5, 3 |
  6, 5, 7, 6, 5, 7, 6 |
  5, 4, 6, 5, 4, 6, 5 |
  4, 6, 5, 4, 6, 4, 7
|];

int: total_demand = sum(j in STORES)(demand[j]);

array[CENTERS] of var 0..1: open;
array[CENTERS, STORES] of var 0..total_demand: ship;

var int: total_cost;

constraint forall(j in STORES) (
  sum(i in CENTERS)(ship[i,j]) = demand[j]
);

constraint forall(i in CENTERS) (
  sum(j in STORES)(ship[i,j]) <= capacity[i] * open[i]
);

constraint total_cost =
  sum(i in CENTERS)(open_cost[i] * open[i]) +
  sum(i in CENTERS, j in STORES)(trans_cost[i,j] * ship[i,j]);

solve minimize total_cost;

output ["total_cost = ", show(total_cost), "\n"];