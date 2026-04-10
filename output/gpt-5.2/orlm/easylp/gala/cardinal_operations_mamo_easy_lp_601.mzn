% Resource allocation optimization for four healthcare services
% All data embedded as requested.

include "globals.mzn";

% Decision variables (integer allocations)
var 50..150: x1;
var 80..120: x2;
var 20..70:  x3;
var 30..60:  x4;

% Constraints
constraint x1 + x2 <= 200;
constraint x3 + x4 <= 180;

% 0.7*x1 - x3 >= 0  ->  7*x1 - 10*x3 >= 0
constraint 7 * x1 - 10 * x3 >= 0;

% 0.5*x2 - x4 >= 0  ->  x2 - 2*x4 >= 0
constraint x2 - 2 * x4 >= 0;

% Objective: minimize total cost.
% Costs: 0.5, 0.2, 3, 1.5
% Multiply by 10 to avoid fractions:
% minimize 10*cost = 5*x1 + 2*x2 + 30*x3 + 15*x4
var int: cost10 = 5*x1 + 2*x2 + 30*x3 + 15*x4;
solve minimize cost10;

% Rounded total cost (nearest whole number):
% total_cost = cost10 / 10
% nearest integer = floor(total_cost + 0.5) = floor((cost10 + 5)/10)
var int: rounded_cost = (cost10 + 5) div 10;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "TotalCost = ", show(cost10 / 10.0), "\n",
  "RoundedTotalCost = ", show(rounded_cost), "\n"
];