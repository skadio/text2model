% Vehicle allocation across routes X, Y, Z (integer linear minimization)

include "globals.mzn";

% Data (embedded as required)
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 80;

% Decision variables: number of vehicles on each route (nonnegative integers)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

% Objective: minimize total cost
var 0..10000000: totalCost = costX * X + costY * Y + costZ * Z;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];