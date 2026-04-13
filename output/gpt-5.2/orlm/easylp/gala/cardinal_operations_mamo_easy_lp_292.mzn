% Resource allocation optimization for projects X, Y, Z
% All data embedded as requested.

int: maxTotal = 100;
int: maxX = 50;
int: maxY = 30;
int: maxYZ = 70;

int: costX = 3;
int: costY = 2;
int: costZ = 5;

% Decision variables (whole-number allocations)
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxYZ: Z;   % bounded safely by Y+Z <= 70 and Z >= 0

% Constraints
constraint X + Y + Z <= maxTotal;
constraint X >= 2 * Y + 10;
constraint Y + Z <= maxYZ;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(totalCost), "\n"
];