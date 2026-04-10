include "globals.mzn";

% Data (embedded from problem statement)
int: budget = 1000;

int: maxX = 500;
int: maxY = 400;
int: minZ = 50;

int: costX = 5;
int: costY = 6;
int: costZ = 7;

int: minExpr1 = 10;   % 3X + 2Y - Z >= 10
int: minDiffZY = 30;  % Z - Y >= 30

% Decision variables (whole-number investments)
var 0..maxX: X;
var 0..maxY: Y;
var minZ..budget: Z;

% Constraints
constraint X + Y + Z <= budget;
constraint 3*X + 2*Y - Z >= minExpr1;
constraint Z - Y >= minDiffZY;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost = ", show(total_cost), "\n"
];