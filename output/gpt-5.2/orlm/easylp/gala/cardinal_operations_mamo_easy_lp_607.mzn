include "globals.mzn";

% Resource allocation decision variables (whole numbers)
var 0..2000: x1;
var 0..1500: x2;
var 500..1500: x3;
var 500..2000: x4;

% Constraints
constraint x1 + x2 <= 5000;
constraint x2 >= x3 + 1000;
constraint x3 + 2 * x4 <= 3000;
constraint x4 >= x1 + 100;

% Objective: minimize total cost (in "units" per resource unit)
% Costs: 0.5, 0.3, 0.4, 0.6
%
% To avoid floats in the solver, scale by 10:
% min 10*cost = 5*x1 + 3*x2 + 4*x3 + 6*x4
var int: cost10 = 5*x1 + 3*x2 + 4*x3 + 6*x4;

solve minimize cost10;

% Report minimum total cost "in thousands" rounded to one decimal.
% Here: cost = cost10/10.0, and we format to one decimal.
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_cost_thousands=", show(fix(cost10) div 10), ".", show((fix(cost10) mod 10)), "\n"
];