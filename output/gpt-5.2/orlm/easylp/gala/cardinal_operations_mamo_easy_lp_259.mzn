include "globals.mzn";

% Data (embedded as required)
int: costX = 5;
int: costY = 6;
int: costZ = 3;

int: Xmax = 700;
int: Ymax = 500;
int: Zmax = 600;

int: capXY = 1000;
int: capYZ = 1200;

int: minDiffXZ = 200;

% Decision variables: whole-number allocations
var 0..Xmax: X;
var 0..Ymax: Y;
var 0..Zmax: Z;

% Constraints
constraint X + Y <= capXY;
constraint Y + Z <= capYZ;
constraint abs(X - Z) >= minDiffXZ;

% Objective: minimize total transportation cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total transportation cost (rounded) = ", show(totalCost), "\n"
];