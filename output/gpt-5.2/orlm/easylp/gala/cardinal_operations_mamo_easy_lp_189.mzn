% Manufacturing cost minimization (all data embedded)

include "globals.mzn";

% Data
int: cX = 10;
int: cY = 15;
int: cZ = 20;

int: maxXY = 5000;
int: maxYZ = 4000;
int: minXZ = 2000;

% Decision variables (nonnegative integer production quantities)
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxYZ: Z;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

% Objective: minimize total cost
var int: totalCost = cX * X + cY * Y + cZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];