include "globals.mzn";

% Resource allocation variables (integers)
var 0..400: x1;
var 0..300: x2;
var 50..200: x3;
var 30..60:  x4;

% Constraints
constraint x1 + x2 <= 500;
constraint 2*x1 + 3*x3 >= 300;

% "x4 should not exceed half of x2 by more than 100": x4 <= (x2/2) + 100
% To keep it integer-safe: 2*x4 <= x2 + 200
constraint 2*x4 <= x2 + 200;

% Exact difference constraint
constraint x2 + x4 - x1 - x3 = 80;

% Objective: minimize total cost
% Costs: 0.5, 0.3, 0.4, 0.6 -> scale by 10 to avoid floating point
var int: cost10 = 5*x1 + 3*x2 + 4*x3 + 6*x4;

solve minimize cost10;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost_rounded=", show((cost10 + 5) div 10), "\n",
  "min_total_cost_exact=", show(cost10), "/10\n"
];