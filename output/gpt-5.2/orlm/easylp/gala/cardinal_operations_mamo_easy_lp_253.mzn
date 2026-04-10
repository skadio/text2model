include "globals.mzn";

% Data (embedded from problem description)
int: maxXY = 100;
int: maxXZ = 80;
int: minYZ = 70;

int: cX = 2;
int: cY = 3;
int: cZ = 1;

% Decision variables (whole-number allocations)
var 0..max(maxXY, maxXZ): X;
var 0..maxXY: Y;
var 0..maxXZ: Z;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z <= maxXZ;
constraint Y + Z >= minYZ;

% Objective: minimize total cost
var int: totalCost = cX * X + cY * Y + cZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];