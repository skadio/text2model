% Fund allocation optimization (all data embedded)

include "globals.mzn";

% Decision variables: whole dollars allocated to each project
var 0..5000: X;
var 0..5000: Y;
var 0..5000: Z;

% Total budget constraint
constraint X + Y + Z <= 5000;

% Strategic/ROI constraints
constraint X >= 2*Y + 1000;
constraint Z >= Y + 1500;

% Cost per dollar allocated
int: cX = 10;
int: cY = 15;
int: cZ = 20;

% Objective: minimize total cost
var int: totalCost = cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(totalCost), "\n"
];