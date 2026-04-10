% Transportation resource allocation (integer linear optimization)

% Decision variables (whole numbers)
var 0..300: x1;   % Route X1 (bounded by x1+x2 <= 300)
var 0..300: x2;   % Route X2
var 0..500: x3;   % Route X3 (bounded by x3+x4 <= 500)
var 0..500: x4;   % Route X4

% Constraints
constraint x1 + x2 <= 300;
constraint x3 + x4 <= 500;

% 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
% Multiply by 10 to keep everything integral:
% 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000
constraint 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000;

% (x3 - 0.8*x4) - (x1 + x2) <= 200
% Multiply by 10:
% 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000
constraint 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000;

% Objective: minimize total cost
% Costs: 0.5, 0.6, 0.8, 1.2
% Multiply by 10: minimize 5*x1 + 6*x2 + 8*x3 + 12*x4 (tenths of a unit)
var int: cost10 = 5*x1 + 6*x2 + 8*x3 + 12*x4;

solve minimize cost10;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "min_cost = ", show(fix(cost10) / 10.0), "\n"
];