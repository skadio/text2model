include "globals.mzn";

% Data (embedded as required)
int: maxBudget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 50;   % $ per unit effectiveness (treated as per-budget-unit cost)
int: costY = 60;
int: costZ = 70;

% Decision variables: whole-dollar budgets allocated to each channel
var minX..maxBudget: X;
var minY..maxBudget: Y;
var minZ..maxBudget: Z;

% Total budget cannot exceed $1000
constraint X + Y + Z <= maxBudget;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "Total budget = $", show(X+Y+Z), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];