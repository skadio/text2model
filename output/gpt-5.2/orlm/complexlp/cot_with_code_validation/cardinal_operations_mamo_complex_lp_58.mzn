% Parameters
int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [133, 189, 446, 346, 184];
array[R] of int: demand = [146, 270, 313, 102, 412];

array[R, R] of int: cost =
[| 0, 24, 32, 44, 46
 | 41, 0,  6, 11, 49
 | 40, 10, 0, 40, 45
 | 22, 22, 34, 0,  1
 | 46, 14, 35, 36, 0 |];

int: total_supply = sum(i in R)(supply[i]);
int: total_demand = sum(i in R)(demand[i]);
int: max_ship = total_supply;

% Variables
array[R, R] of var 0..max_ship: x;  % shipped from i to j
var 0..(max_ship * max(cost)): total_cost;

% Constraints
constraint total_supply >= total_demand;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R)(
  supply[j] - sum(k in R)(x[j,k]) + sum(i in R)(x[i,j]) >= demand[j]
);

% Objective
constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);
solve minimize total_cost;