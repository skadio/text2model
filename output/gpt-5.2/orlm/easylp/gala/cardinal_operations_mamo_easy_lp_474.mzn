include "globals.mzn";

% Data (embedded from description)
int: maxTours = 50;
int: minExpr = 40;              % 2*X + 4*Y >= 40
int: maxDiversity = 60;         % 3*X - 1*Y <= 60
int: costX = 500;
int: costY = 1000;

% Decision variables (integer number of tours)
var 0..maxTours: X;
var 0..maxTours: Y;

% Constraints
constraint X + Y <= maxTours;
constraint 2*X + 4*Y >= minExpr;
constraint 3*X - Y <= maxDiversity;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];