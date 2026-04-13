int: N = 6;
set of int: W = 1..N;

array[W] of int: supply = [497, 39, 416, 71, 445, 471];
array[W] of int: demand = [161, 257, 252, 251, 372, 370];

array[W, W] of int: cost = [|
  0,  5,  7,  5, 27, 49 |
 31,  0, 14, 31,  3,  4 |
  9, 13,  0, 23, 38, 19 |
 47, 34,  7,  0, 34, 35 |
 21, 11,  6,  7,  0, 50 |
 28, 41, 34, 17, 32,  0
|];

int: total_supply = sum(i in W)(supply[i]);
int: total_demand = sum(i in W)(demand[i]);
int: max_ship = total_supply;

array[W, W] of var 0..max_ship: ship;

var 0..(max_ship * max([cost[i,j] | i in W, j in W])): total_cost;

constraint total_supply >= total_demand;
constraint forall(i in W)(ship[i,i] = 0);

constraint forall(i in W)(
  supply[i] + sum(j in W)(ship[j,i]) - sum(j in W)(ship[i,j]) >= demand[i]
);

constraint sum(i in W, j in W)(ship[i,j]) = total_supply - total_demand;

constraint total_cost = sum(i in W, j in W)(cost[i,j] * ship[i,j]);

solve minimize total_cost;