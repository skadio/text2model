include "globals.mzn";

% Data (embedded from the problem description)
int: capacity = 500;

int: minX = 0;  int: maxX = 300;
int: minY = 0;  int: maxY = 200;
int: minZ = 0;  int: maxZ = 100;

int: costX = 50;
int: costY = 60;
int: costZ = 20;

int: demand1 = 200;  % 2*X + 1*Y >= 200
int: demand2 = 150;  % Y + Z >= 150

% Decision variables (integer production quantities)
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

% Constraints
constraint X + Y + Z <= capacity;
constraint 2*X + Y >= demand1;
constraint Y + Z >= demand2;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = $", show(totalCost), "\n"
];