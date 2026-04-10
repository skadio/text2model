% Tourism agency resource allocation (integer optimization)
include "globals.mzn";

% Data (embedded as required)
int: budget = 200;
int: minEffect = 150;
int: maxDiff = 50;

int: costX = 50;
int: costY = 80;

% Decision variables (integer units)
var 0..budget: X;
var 0..budget: Y;

% Constraints
constraint X + Y <= budget;
constraint 2 * X + Y >= minEffect;
constraint abs(X - Y) <= maxDiff;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];