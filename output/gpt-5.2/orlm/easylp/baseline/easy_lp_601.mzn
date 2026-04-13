% Resource allocation for four healthcare services (integer allocations)

var 50..150: x1;
var 80..120: x2;
var 20..70:  x3;
var 30..60:  x4;

% Constraints
constraint x1 + x2 <= 200;
constraint 7 * x1 - 10 * x3 >= 0;   % 0.7*x1 - x3 >= 0 without fractions
constraint x2 - 2 * x4 >= 0;        % 0.5*x2 - x4 >= 0 without fractions
constraint x3 + x4 <= 180;

% Objective: minimize total cost.
% Use scaled-by-10 integer objective to avoid floating-point issues:
% 0.5=5/10, 0.2=2/10, 3=30/10, 1.5=15/10
var int: cost10 = 5*x1 + 2*x2 + 30*x3 + 15*x4;
solve minimize cost10;

% Output minimum total cost rounded to nearest whole number.
% Since total cost = cost10 / 10, rounding to nearest integer is:
% round(cost10/10) = (cost10 + 5) div 10
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost_rounded=", show((cost10 + 5) div 10), "\n",
  "min_total_cost_exact=", show(cost10), "/10\n"
];