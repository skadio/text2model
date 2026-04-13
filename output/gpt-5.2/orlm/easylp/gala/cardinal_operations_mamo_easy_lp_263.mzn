% Hiring cost minimization for departments X, Y, Z
% All data embedded as requested.

int: costX = 5000;
int: costY = 7000;
int: costZ = 10000;

int: maxTotalHires = 50;

int: minX = 10;
int: minY = 15;
int: minZ = 20;

var 0..maxTotalHires: X;
var 0..maxTotalHires: Y;
var 0..maxTotalHires: Z;

constraint X + Y + Z <= maxTotalHires;
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total hiring cost = $", show(totalCost), "\n"
];