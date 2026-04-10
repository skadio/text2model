include "globals.mzn";

% Resource allocation variables (whole numbers)
% Bounds are not explicitly provided in the statement; use nonnegative integers.
var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

% Objective: minimize total cost
var int: total_cost = 100*x1 + 150*x2 + 80*x3 + 50*x4;

% Constraints
constraint 3*x1 + 2*x2 - x3 <= 5000;
constraint -x1 + 4*x2 + x4 >= 2000;
constraint 5*x3 - x1 - x2 - x4 = 4000;

% Handle fractional coefficients by multiplying by 2:
% 6*x2 + 7.5*x3 - 8.5*x4 - x1 <= 3000
% => 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000
constraint 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];