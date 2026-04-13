include "globals.mzn";

% Decision variables (whole-number allocations)
var 0..1000: x1;
var 0..1000: x2;
var 0..1200: x3;
var 0..1200: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 1200;

% x1 >= (4/3) * x3  ->  3*x1 >= 4*x3
constraint 3 * x1 >= 4 * x3;

% x2 > (9/7) * x4 by at least 200:
% x2 >= (9/7)*x4 + 200  ->  7*x2 >= 9*x4 + 1400
constraint 7 * x2 >= 9 * x4 + 1400;

% Objective: minimize total cost
var int: total_cost = 2 * x1 + 3 * x2 + 5 * x3 + 4 * x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];