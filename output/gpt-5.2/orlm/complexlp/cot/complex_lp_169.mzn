% Parameters (with values embedded)
int: M = 6; % potential distribution centers
int: N = 8; % retail stores

array[1..M] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[1..M, 1..N] of int: transCost =
[
  % stores 1..8
  [2, 3, 4, 2, 3, 4, 3, 5], % center 1
  [2, 4, 3, 2, 4, 3, 4, 2], % center 2
  [5, 4, 5, 3, 2, 4, 3, 4], % center 3
  [4, 3, 2, 4, 3, 2, 4, 3], % center 4
  [5, 1, 2, 3, 4, 5, 1, 2], % center 5
  [1, 2, 3, 4, 1, 2, 3, 4]  % center 6
];

array[1..N] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[1..M] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(j in 1..N)(demand[j]);

% Variables
array[1..M] of var 0..1: open; % 1 if center i is opened
array[1..M, 1..N] of var 0..totalDemand: ship; % units shipped from center i to store j

% Constraints
constraint
  forall(j in 1..N)(
    sum(i in 1..M)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in 1..M)(
    sum(j in 1..N)(ship[i,j]) <= capacity[i] * open[i]
  );

% Objective
var int: totalCost =
  sum(i in 1..M)(openCost[i] * open[i]) +
  sum(i in 1..M, j in 1..N)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;