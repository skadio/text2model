include "globals.mzn";

% Decision variables: integer resource allocations (units)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2 * x3 + x4 <= 800;
constraint 3 * x1 + 4 * x2 - x3 >= 500;
constraint x2 >= 2 * x4;

% Objective: minimize total cost
var int: total_cost = 20 * x1 + 30 * x2 + 10 * x3 + 15 * x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];