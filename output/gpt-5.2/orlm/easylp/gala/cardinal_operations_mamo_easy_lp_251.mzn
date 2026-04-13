include "globals.mzn";

% Data (embedded as requested)
int: minX = 0; int: maxX = 10;
int: minY = 0; int: maxY = 8;
int: minZ = 0; int: maxZ = 6;

int: totalHoursMax = 24;
int: yzHoursMax = 16;

int: costX = 8;
int: costY = 6;
int: costZ = 5;

% Decision variables: integer working hours
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

% Constraints
constraint X + Y + Z <= totalHoursMax;
constraint X >= Y + 2;
constraint Y + Z <= yzHoursMax;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X=", show(X), " hours\n",
  "Y=", show(Y), " hours\n",
  "Z=", show(Z), " hours\n",
  "Minimum total cost (nearest whole $) = $", show(totalCost), "\n"
];