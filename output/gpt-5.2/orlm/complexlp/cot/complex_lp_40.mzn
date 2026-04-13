% Parameters (with values embedded)
int: N = 6;
set of int: W = 1..N;

array[W] of int: supply = [497, 39, 416, 71, 445, 471];
array[W] of int: demand = [161, 257, 252, 251, 372, 370];

array[W, W] of int: cost =
[|  0,  5,  7,  5, 27, 49
 | 31,  0, 14, 31,  3,  4
 |  9, 13,  0, 23, 38, 19
 | 47, 34,  7,  0, 34, 35
 | 21, 11,  6,  7,  0, 50
 | 28, 41, 34, 17, 32,  0 |];

% Variables
array[W, W] of var 0..max(supply): x; % units shipped from i to j

% Constraints
constraint forall(i, j in W where i == j) (x[i,j] = 0);

% Ship out any excess above demand; ship in any deficit below demand
constraint forall(i in W) (
  sum(j in W)(x[i,j]) = max(0, supply[i] - demand[i])
);

constraint forall(j in W) (
  sum(i in W)(x[i,j]) = max(0, demand[j] - supply[j])
);

% Objective
var int: total_cost = sum(i, j in W)(cost[i,j] * x[i,j]);
solve minimize total_cost;