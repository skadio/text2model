% Parameters
int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [120, 330, 400, 400, 600];
array[R] of int: demand = [150, 200, 600, 200, 400];

array[R, R] of int: cost =
  [|  0,  0, 13, 11, 28
   |  0,  0, 18,  8, 46
   |  0,  0,  0,  9, 27
   |  0,  0,  0,  0, 20
   |  0,  0,  0,  0,  0 |];

% Variables
array[R, R] of var 0..max(supply): x;

var 0..(max(cost) * sum(supply)): total_cost;

% Constraints
constraint forall(i, j in R where i >= j) (x[i, j] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i, j]) <= supply[i]
);

constraint forall(j in R)(
  sum(i in R)(x[i, j]) - sum(k in R)(x[j, k]) >= demand[j] - supply[j]
);

constraint total_cost = sum(i, j in R)(cost[i, j] * x[i, j]);

% Objective
solve minimize total_cost;