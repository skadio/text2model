% Resource allocation with minimum cost (all data embedded)

include "globals.mzn";

% Parameters
int: budget = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

% Decision variables: whole-number allocations
var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

% Budget constraint (total allocation cannot exceed 1000 units)
constraint X + Y + Z <= budget;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (nearest dollar) = ", show(totalCost), "\n"
];