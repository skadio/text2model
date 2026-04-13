% Resource allocation optimization for initiatives X, Y, Z
% Data is embedded as required.

include "globals.mzn";

% Bounds (operational/strategic considerations)
% Not explicitly given in the description, so we use natural nonnegative allocations
% with a safe upper bound from the total budget constraint.
int: BUDGET = 1000;

int: cX = 2;
int: cY = 3;
int: cZ = 4;

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2 * Y + 100;
constraint abs(Y - Z) <= 50;
constraint X + Z >= 300;

% Objective: minimize total cost
var int: total_cost = cX * X + cY * Y + cZ * Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];