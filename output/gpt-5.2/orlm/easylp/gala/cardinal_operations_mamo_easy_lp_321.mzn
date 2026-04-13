include "globals.mzn";

% Data (embedded from the problem statement)
int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxX = 100;
int: maxY = 80;
int: maxZ = 60;

% Decision variables: whole-number cargo allocations
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint 2*X + 3*Y + Z >= 30;
constraint X + 4*Y + 2*Z <= 50;
constraint (X - Y) + Z >= 10;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];