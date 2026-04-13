include "globals.mzn";

% Data (embedded from problem statement)
int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;
int: maxDiffXY = 200;

int: costX = 20;
int: costY = 30;
int: costZ = 10;

% Decision variables (nonnegative integer resource units)
var 0..max(maxXY, maxYZ): X;
var 0..max(maxXY, maxYZ): Y;
var 0..max(maxXY, maxYZ): Z;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;
constraint abs(X - Y) <= maxDiffXY;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];