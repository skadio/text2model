include "globals.mzn";

% Data embedded from the description
int: total_budget = 1000;

int: reqX = 500;
int: reqY = 400;
int: reqZ = 700;

int: min_diff_2X_minus_Y = 200;
int: min_diff_Z_minus_Y  = 50;

% Decision variables: whole-number support allocated to each division
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

% Constraints (strategic guidelines)
constraint X + Y + Z <= total_budget;
constraint 2 * X - Y >= min_diff_2X_minus_Y;
constraint Z - Y >= min_diff_Z_minus_Y;

% Must meet each division's required support
constraint X >= reqX;
constraint Y >= reqY;
constraint Z >= reqZ;

% Objective: minimum total support required
var 0..total_budget: totalSupport = X + Y + Z;
solve minimize totalSupport;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total support (units) = ", show(totalSupport), "\n"
];