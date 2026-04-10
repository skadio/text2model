% Resource allocation optimization for three departments:
% X = purchasing, Y = sales, Z = logistics

include "globals.mzn";

% Parameters (embedded from the problem statement)
int: costX = 5;
int: costY = 3;
int: costZ = 4;

int: maxX = 500;
int: maxY = 300;
int: maxZ = 200;

int: capXY = 1000;
int: capYZ = 800;

int: minDiffXZ = 200;

% Decision variables (whole numbers)
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y <= capXY;
constraint Y + Z <= capYZ;
constraint abs(X - Z) >= minDiffXZ;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X(purchasing) = ", show(X), "\n",
  "Y(sales)      = ", show(Y), "\n",
  "Z(logistics)  = ", show(Z), "\n",
  "TotalCost     = ", show(totalCost), "\n"
];