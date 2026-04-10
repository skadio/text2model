int: M = 5;
int: N = 9;

set of int: CENTERS = 1..M;
set of int: STORES  = 1..N;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000, 160000];
array[CENTERS] of int: capacity  = [1825, 1821, 1365, 1929, 1502];
array[STORES] of int: demand     = [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[CENTERS, STORES] of int: ship_cost = array2d(CENTERS, STORES, [
  5, 2, 3, 3, 3, 5, 4, 3, 5,
  2, 4, 2, 4, 5, 1, 4, 2, 5,
  4, 1, 1, 3, 3, 2, 4, 4, 3,
  4, 4, 1, 3, 5, 3, 5, 1, 2,
  4, 1, 4, 2, 2, 1, 2, 5, 2
]);

int: total_demand = sum(j in STORES)(demand[j]);
int: max_ship_cost = max(i in CENTERS, j in STORES)(ship_cost[i,j]);
int: max_total_cost = sum(i in CENTERS)(open_cost[i]) + total_demand * max_ship_cost;

array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: flow;

var 0..max_total_cost: total_cost;

constraint forall(j in STORES)(
  sum(i in CENTERS)(flow[i,j]) = demand[j]
);

constraint forall(i in CENTERS)(
  sum(j in STORES)(flow[i,j]) <= capacity[i] * bool2int(open[i])
);

constraint total_cost =
  sum(i in CENTERS)(open_cost[i] * bool2int(open[i])) +
  sum(i in CENTERS, j in STORES)(ship_cost[i,j] * flow[i,j]);

solve minimize total_cost;