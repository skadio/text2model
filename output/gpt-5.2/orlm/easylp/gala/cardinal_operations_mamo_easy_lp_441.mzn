% Inventory optimization for two product categories X and Y
% All data is embedded as requested.

include "globals.mzn";

% Parameters (from problem statement)
int: costX = 20;
int: costY = 30;

int: maxX = 400;
int: maxY = 300;

int: storageCap = 500;

int: minEffect = 1000;    % 3*X + 2*Y >= 1000
int: diffLimit = 600;     % 4*X - Y <= 600  (interpreting "should not exceed by more than 600")

% Decision variables (whole units)
var 0..maxX: X;
var 0..maxY: Y;

% Constraints
constraint X + Y <= storageCap;
constraint 3*X + 2*Y >= minEffect;
constraint 4*X - Y <= diffLimit;

% Objective: minimize carrying cost
var int: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];