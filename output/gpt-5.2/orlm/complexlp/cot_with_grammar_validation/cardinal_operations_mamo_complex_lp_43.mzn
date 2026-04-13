% Parameters
int: N = 4;
set of int: W = 1..N;

array[W] of int: stock = [500, 497, 354, 223];
array[W] of int: need  = [ 17,  65,  26, 332];

array[W, W] of int: cost =
[|  0, 17,  3,  5
 | 39,  0, 18, 50
 |  8, 45,  0, 15
 | 11,  4, 29,  0
 |];

% Variables
array[W, W] of var 0..max(stock): x;  % x[i,j] = tons moved from i to j

var 0..(max(cost) * N * max(stock)): total_cost;

% Constraints
constraint
  forall(i in W)(x[i,i] = 0);

constraint
  forall(i in W)(
    sum(j in W)(x[i,j]) <= stock[i]
  );

constraint
  forall(k in W)(
    stock[k] - sum(j in W)(x[k,j]) + sum(i in W)(x[i,k]) >= need[k]
  );

constraint
  total_cost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;