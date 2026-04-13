% Supply chain resource allocation (integer) - minimize total cost
include "globals.mzn";

% Decision variables (whole-number allocations)
var 0..500: x1;
var 0..600: x2;
var 0..400: x3;
var 0..300: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 800;

% 0.5*x1 - 0.6*x2 >= 50  -> multiply by 10: 5*x1 - 6*x2 >= 500
constraint 5*x1 - 6*x2 >= 500;

% 0.7*x4 - x3 <= 70 -> multiply by 10: 7*x4 - 10*x3 <= 700
constraint 7*x4 - 10*x3 <= 700;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];