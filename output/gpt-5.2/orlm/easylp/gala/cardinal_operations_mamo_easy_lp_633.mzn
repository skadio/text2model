include "globals.mzn";

% Decision variables (integer allocations within given bounds)
var 0..30: x1;
var 0..20: x2;
var 0..40: x3;
var 0..50: x4;

% Constraints
constraint x1 + 2*x2 >= 10;
constraint 2*x3 - x4 <= 15;
constraint x1 + x3 - 3*x2 = 8;
constraint x1 - x2 - x4 <= 25;

% Objective: minimize total cost
var int: total_cost = 4*x1 + 3*x2 + 5*x3 + 6*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];