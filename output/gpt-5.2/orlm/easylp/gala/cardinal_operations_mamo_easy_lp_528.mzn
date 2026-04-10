include "globals.mzn";

% Data (embedded from problem statement)
int: budgetMax = 1000;
int: minXminusY = 50;
int: maxAbsZminusX = 200;
int: minYplusZ = 400;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Decision variables: whole-number allocations
var 0..budgetMax: X;
var 0..budgetMax: Y;
var 0..budgetMax: Z;

% Constraints
constraint X + Y + Z <= budgetMax;
constraint X >= Y + minXminusY;
constraint abs(Z - X) <= maxAbsZminusX;
constraint Y + Z >= minYplusZ;

% Objective: minimize total cost
var 0..(costX*budgetMax + costY*budgetMax + costZ*budgetMax): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (nearest dollar) = ", show(totalCost), "\n"
];