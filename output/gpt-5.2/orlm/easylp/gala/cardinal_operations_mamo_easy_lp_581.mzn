include "globals.mzn";

% Decision variables (integer units)
var 10..100: x1;   % residential
var 20..150: x2;   % commercial
var 15..120: x3;   % industrial

% Total units limit
constraint x1 + x2 + x3 <= 200;

% Profitability (ROI) constraint:
% 0.5*x1 - 0.3*x2 + 0.4*x3 >= 50
% Multiply by 10 to keep it integral: 5*x1 - 3*x2 + 4*x3 >= 500
constraint 5*x1 - 3*x2 + 4*x3 >= 500;

% Risk constraint:
% 0.2*x1 + 0.6*x2 - 0.8*x3 <= 30
% Multiply by 10: 2*x1 + 6*x2 - 8*x3 <= 300
constraint 2*x1 + 6*x2 - 8*x3 <= 300;

% Objective: minimize total cost
var int: total_cost = 500*x1 + 300*x2 + 400*x3;

solve minimize total_cost;

output [
  "x1(residential) = ", show(x1), "\n",
  "x2(commercial)  = ", show(x2), "\n",
  "x3(industrial)  = ", show(x3), "\n",
  "total_cost = $", show(total_cost), "\n"
];