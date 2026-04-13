% Resource allocation: X (patient care), Y (R&D), Z (admin)
% Minimize total cost subject to linear integer constraints.

int: maxXY = 150;
int: minXZ = 100;
int: maxDiffYZ = 60;
int: maxLessXThanZ = 10;

int: costX = 50;
int: costY = 80;
int: costZ = 30;

% Safe upper bounds derived from constraints
% X + Y <= 150 and X + Z >= 100 with X >= 0 implies Z can be as high as 100 + X (not bounded),
% but also X >= Z - 10 and X + Y <= 150 implies Z <= X + 10 <= 160.
int: U = 200;

var 0..U: X;
var 0..U: Y;
var 0..U: Z;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint abs(Y - Z) <= maxDiffYZ;
constraint X >= Z - maxLessXThanZ;

% Objective
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];