% Production planning for products X, Y, Z (all integer)
include "globals.mzn";

% Embedded data (from problem statement)
int: capacity = 1000;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: minDemand_X2plusY = 500;   % 2*X + Y >= 500
int: minBalance_XplusZ  = 400;  % X + Z >= 400

% Decision variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

% Constraints
constraint X + Y + Z <= capacity;
constraint 2 * X + Y >= minDemand_X2plusY;
constraint X + Z >= minBalance_XplusZ;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(totalCost), "\n"
];