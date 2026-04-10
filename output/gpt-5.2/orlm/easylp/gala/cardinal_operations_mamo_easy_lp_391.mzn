% Fund allocation optimization for four programs x1..x4
% All data embedded as required.

include "globals.mzn";

% Decision variables (whole-number allocations).
% The description mentions "specified bounds" but does not provide numeric bounds.
% Use a safe, implied nonnegativity domain with an upper bound large enough to not cut off optima.
int: U = 1000;
var 0..U: x1;
var 0..U: x2;
var 0..U: x3;
var 0..U: x4;

% Constraints
constraint x1 + x2 >= 20;
constraint x3 + x4 <= 40;
constraint x1 - 2 * x3 >= 5;
constraint x4 - x2 <= 10;

% Objective: minimize total cost
var 0..intmax: total_cost = 10*x1 + 15*x2 + 25*x3 + 35*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];