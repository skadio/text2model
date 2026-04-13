% Parameters (with values embedded)
int: N = 6; % distribution centers
int: M = 4; % retail stores

array[1..N] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[1..N, 1..M] of int: transCost =
 [| 2, 3, 3, 3
  | 5, 4, 3, 5
  | 2, 4, 2, 4
  | 5, 1, 4, 2
  | 5, 4, 1, 1
  | 3, 3, 2, 4 |];

array[1..M] of int: demand = [589, 962, 966, 643];

array[1..N] of int: capacity = [1631, 1954, 1446, 820, 1640, 966];

int: totalDemand = sum(j in 1..M)(demand[j]);
int: maxUnitCost = max(i in 1..N, j in 1..M)(transCost[i,j]);
int: maxObj = sum(i in 1..N)(openCost[i]) + maxUnitCost * totalDemand;

% Variables
array[1..N] of var 0..1: open;
array[1..N, 1..M] of var 0..totalDemand: ship;
var 0..maxObj: totalCost;

% Constraints
constraint forall(j in 1..M)(
  sum(i in 1..N)(ship[i,j]) = demand[j]
);

constraint forall(i in 1..N)(
  sum(j in 1..M)(ship[i,j]) <= capacity[i] * open[i]
);

constraint totalCost =
  sum(i in 1..N)(openCost[i] * open[i]) +
  sum(i in 1..N, j in 1..M)(transCost[i,j] * ship[i,j]);

% Objective
solve minimize totalCost;

output [show(totalCost)];