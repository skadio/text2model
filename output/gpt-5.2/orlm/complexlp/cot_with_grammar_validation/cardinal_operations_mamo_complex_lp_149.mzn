int: M = 6;
int: N = 9;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];
array[ST] of int: demand = [401, 789, 965, 505, 876, 801, 955, 561, 601];
array[DC] of int: capacity = [1795, 1069, 1615, 1255, 1816, 1095];

array[DC, ST] of int: trans_cost = [|
  2, 3, 4, 5, 6, 7, 8, 3, 2 |
  4, 2, 3, 4, 5, 6, 7, 5, 4 |
  3, 4, 2, 3, 4, 5, 6, 4, 3 |
  5, 3, 4, 2, 3, 4, 5, 3, 5 |
  6, 5, 3, 4, 2, 3, 4, 2, 6 |
  4, 6, 5, 3, 4, 2, 3, 4, 4
|];

int: total_demand = sum(i in ST)(demand[i]);
int: max_flow = total_demand;

array[DC] of var 0..1: open;
array[DC, ST] of var 0..max_flow: ship;

var int: total_cost;

constraint forall(i in ST) (
  sum(j in DC)(ship[j, i]) = demand[i]
);

constraint forall(j in DC) (
  sum(i in ST)(ship[j, i]) <= capacity[j] * open[j]
);

constraint total_cost =
  sum(j in DC)(open_cost[j] * open[j]) +
  sum(j in DC, i in ST)(trans_cost[j, i] * ship[j, i]);

solve minimize total_cost;