% Parameters (with values embedded)
int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..800:  Z;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

% Objective
var int: totalCost = costX*X + costY*Y + costZ*Z;
solve minimize totalCost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];