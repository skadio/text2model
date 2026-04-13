% Resource allocation between projects X and Y (integers)
% Minimize cost subject to linear constraints

include "globals.mzn";

% Data (embedded from description)
int: min_total = 100;
int: aX = 5;
int: aY = -2;
int: rhs = 50;

int: costX = 10;
int: costY = 20;

% Decision variables (nonnegative integer allocations)
var 0..1000: X;
var 0..1000: Y;

% Constraints
constraint X + Y >= min_total;
constraint aX * X + aY * Y <= rhs;   % 5X - 2Y <= 50

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];