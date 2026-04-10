% Parameters (with values embedded)
int: M = 4; % potential distribution centers
int: N = 6; % retail stores

array[1..M] of int: openCost = [151000, 192000, 114000, 171000];

array[1..M, 1..N] of int: shipCost =
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[1..N] of int: demand = [910, 875, 589, 962, 966, 643];
array[1..M] of int: capacity = [1631, 1954, 1446, 820];

int: totalDemand = sum(j in 1..N)(demand[j]);

% Variables
array[1..M] of var 0..1: open; % 1 if distribution center i is opened
array[1..M, 1..N] of var 0..totalDemand: x; % units shipped from center i to store j

% Constraints
constraint
  forall(j in 1..N)(
    sum(i in 1..M)(x[i,j]) = demand[j]
  );

constraint
  forall(i in 1..M)(
    sum(j in 1..N)(x[i,j]) <= capacity[i] * open[i]
  );

% Objective
var int: totalCost =
  sum(i in 1..M)(openCost[i] * open[i]) +
  sum(i in 1..M, j in 1..N)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;