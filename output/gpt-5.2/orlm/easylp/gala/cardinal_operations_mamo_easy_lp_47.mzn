% Resource allocation: minimize cost subject to linear constraints
include "globals.mzn";

% Embedded data
int: min_total = 100;
int: max_effort = 250;          % 2*X + Y <= 250
int: costX = 50;
int: costY = 80;

% Decision variables (nonnegative integers)
var 0..max_effort: X;
var 0..max_effort: Y;

% Constraints
constraint X + Y >= min_total;
constraint 2*X + Y <= max_effort;

% Objective
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];