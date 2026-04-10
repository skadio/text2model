% Fleet allocation across three routes X, Y, Z
% Minimize total operating cost subject to capacity and coupling constraints.

int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxX = 700;
int: maxY = 600;
int: maxZ = 400;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total operating cost (rounded) = ", show(totalCost), "\n"
];