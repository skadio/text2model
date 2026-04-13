include "globals.mzn";

% Data (embedded as required)
int: budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Decision variables (integer resource units)
var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

% Budget constraint
constraint X + Y + Z <= budget;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

% Output: minimum total cost, rounded to nearest whole dollar (already integer)
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];