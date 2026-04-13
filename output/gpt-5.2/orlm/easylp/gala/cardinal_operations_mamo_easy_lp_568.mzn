include "globals.mzn";

% Data (embedded as required)
int: costX = 1000;
int: costY = 500;
int: costZ = 1200;

int: maxTotal = 100;

int: X_lb = 0;  int: X_ub = 50;
int: Y_lb = 0;  int: Y_ub = 40;
int: Z_lb = 0;  int: Z_ub = 60;

% Decision variables: units allocated (integers)
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

% Constraints
constraint X + Y + Z <= maxTotal;
constraint X >= Y + 10;
constraint Z <= Y + 20;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];