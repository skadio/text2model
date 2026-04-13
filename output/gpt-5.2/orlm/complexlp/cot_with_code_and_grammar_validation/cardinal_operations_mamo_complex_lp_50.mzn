% Parameters
int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [268, 222, 357, 128, 465, 48];
array[R] of int: demand = [165, 246, 262, 286, 439, 83];

array[R, R] of int: cost =
[| 0, 49, 11, 23,  2, 39
 | 33,  0, 26,  2,  2, 14
 | 12, 31,  0, 36, 30, 34
 | 18, 50, 12,  0, 19, 20
 |  3, 13, 20, 29,  0,  1
 |  2,  9, 50, 36, 39,  0 |];

int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);
int: total_transported = total_supply - total_demand;

% Variables
array[R, R] of var 0..total_supply: x;

var 0..(max(cost) * total_transported): total_cost;

% Constraints
constraint total_supply >= total_demand;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R)(
  sum(i in R)(x[i,j]) - sum(k in R)(x[j,k]) >= demand[j] - supply[j]
);

constraint sum(i in R, j in R)(x[i,j]) = total_transported;

constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;