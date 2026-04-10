% Parameters (with values embedded)
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 20;
int: min2YZ = 10;
int: maxXZ = 15;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxXZ: Z;

% Constraints
constraint X + Y <= maxXY;
constraint 2 * Y + Z >= min2YZ;
constraint X + Z <= maxXZ;

% Objective
var int: totalCost = costX * X + costY * Y + costZ * Z;
solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost=", show(totalCost), "\n"
];