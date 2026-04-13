% Portfolio allocation between two options with integer allocations.
% Data is embedded as requested.

include "globals.mzn";

% Parameters
int: budget = 10000;
int: minX = 2000;
int: minY = 3000;

% Costs per dollar invested (in dollars)
float: costX = 0.02;
float: costY = 0.03;

% Decision variables: integer dollar allocations
var minX..budget: X;
var minY..budget: Y;

% Constraints
constraint X + Y <= budget;

% Objective: minimize total cost
var float: totalCost = costX * int2float(X) + costY * int2float(Y);

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(totalCost), "\n",
  "TotalCostRounded = ", show(round(totalCost)), "\n"
];