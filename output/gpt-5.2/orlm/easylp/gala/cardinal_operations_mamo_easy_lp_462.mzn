% Supply chain resource allocation: minimize cost with linear constraints.
% All data embedded as requested.

include "globals.mzn";

% Parameters
int: max_total = 1000;
int: min_capacity = 2500;
int: max_diff = 300;

int: costX = 7;
int: costY = 5;

% If "specific bounds" are not explicitly given, use natural bounds from the problem context.
int: minX = 0;
int: maxX = max_total;
int: minY = 0;
int: maxY = max_total;

% Decision variables (whole-number allocations)
var minX..maxX: X;
var minY..maxY: Y;

% Constraints
constraint X + Y <= max_total;
constraint 3*X + 2*Y >= min_capacity;
constraint abs(X - Y) <= max_diff;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];