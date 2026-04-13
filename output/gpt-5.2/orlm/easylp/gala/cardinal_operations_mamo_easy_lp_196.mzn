% Investment portfolio cost minimization (all data embedded)

include "globals.mzn";

% Data (from description)
int: budget = 500;
int: minX = 100;
int: minY = 50;
int: minZ = 30;

int: costX = 1000;
int: costY = 1500;
int: costZ = 2000;

% Decision variables: whole-number investment units
var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

% Total cost
var 0..intmax: totalCost = costX * X + costY * Y + costZ * Z;

% Constraints
constraint X + Y + Z <= budget;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];