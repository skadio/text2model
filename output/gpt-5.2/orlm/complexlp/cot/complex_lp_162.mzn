% Parameters (with values embedded)
int: M = 7; % distribution centers
int: N = 4; % retail stores

array[1..M] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[1..M] of int: capacity = [1187, 1400, 1115, 813, 1041, 1576, 1364];
array[1..N] of int: demand   = [884, 420, 566, 673];

array[1..M, 1..N] of int: shipCost =
  [| 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1
   | 4, 2, 5, 4
   | 1, 1, 3, 3
   | 2, 4, 4, 3
   | 4, 4, 1, 3 |];

int: totalDemand = sum(j in 1..N)(demand[j]);

% Variables
array[1..M] of var 0..1: open;
array[1..M, 1..N] of var 0..totalDemand: x;

var int: total_cost;

% Constraints
constraint forall(i in 1..M)(
  sum(j in 1..N)(x[i,j]) <= capacity[i] * open[i]
);

constraint forall(j in 1..N)(
  sum(i in 1..M)(x[i,j]) = demand[j]
);

constraint total_cost =
  sum(i in 1..M)(openCost[i] * open[i]) +
  sum(i in 1..M, j in 1..N)(shipCost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;