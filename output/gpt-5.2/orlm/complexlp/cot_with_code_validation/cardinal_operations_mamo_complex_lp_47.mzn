% Parameters
int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [319, 281, 247, 237, 29, 453];
array[R] of int: demand = [243, 243, 124, 202, 84, 28];

array[R, R] of int: cost = array2d(R, R, [
  0, 11, 30, 12, 48, 23,
  1,  0, 27,  9, 26, 13,
  29, 6,  0, 27, 13, 44,
  6, 50, 12,  0, 19, 32,
  26, 13, 29,  2,  0, 24,
  9, 26,  2, 37, 22,  0
]);

% Variables
int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);
int: max_ship = total_supply;

array[R, R] of var 0..max_ship: x;

var 0..(max_ship * max(cost)): total_cost;

% Constraints
constraint total_supply = total_demand;

constraint forall(i in R)(
  sum(j in R)(x[i,j]) = supply[i]
);

constraint forall(j in R)(
  sum(i in R)(x[i,j]) = demand[j]
);

constraint forall(i in R)(x[i,i] = 0);

constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;