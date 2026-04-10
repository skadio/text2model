include "globals.mzn";

% Data (embedded as required)
int: B = 5000;        % total available budget (dollars)
int: minDiffXY = 1000;
int: maxDiffZY = 1500;

int: cX = 50;         % cost per unit (dollars)
int: cY = 30;
int: cZ = 20;

% Decision variables: integer investments in each channel (dollars)
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

% Constraints
constraint X + Y + Z <= B;
constraint X >= Y + minDiffXY;
constraint abs(Z - Y) <= maxDiffZY;

% Objective: minimize total cost
var 0..(cX*B + cY*B + cZ*B): totalCost = cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];