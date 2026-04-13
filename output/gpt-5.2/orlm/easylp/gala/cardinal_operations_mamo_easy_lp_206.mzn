% Hospital resource allocation across departments X, Y, Z
% Minimize total cost subject to allocation constraints.

include "globals.mzn";

% Data (embedded as required)
int: maxTotal = 150;
int: minXminusY = 10;
int: maxYminusZ = 20;

int: costX = 100;
int: costY = 50;
int: costZ = 30;

% Decision variables (whole numbers)
var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..maxTotal: Z;

% Constraints
constraint X + Y + Z <= maxTotal;
constraint X >= Y + minXminusY;
constraint Y <= Z + maxYminusZ;

% Objective: minimize total cost
var 0..(maxTotal*max([costX,costY,costZ])): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];