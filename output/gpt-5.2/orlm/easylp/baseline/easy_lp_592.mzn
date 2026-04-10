% Transportation resource allocation - all data embedded

% Decision variables (whole-number allocations)
var 0..300: x1;
var 0..300: x2;
var 0..500: x3;
var 0..500: x4;

% Constraints
constraint x1 + x2 <= 300;
constraint x3 + x4 <= 500;

% 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
% Multiply by 10 to avoid decimals: 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000
constraint 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000;

% (x3 - 0.8*x4) - (x1 + x2) <= 200
% Multiply by 10: 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000
constraint 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000;

% Objective: minimize 0.5*x1 + 0.6*x2 + 0.8*x3 + 1.2*x4
% Multiply by 10 for exact integer objective: 5*x1 + 6*x2 + 8*x3 + 12*x4
var int: cost10 = 5*x1 + 6*x2 + 8*x3 + 12*x4;
solve minimize cost10;

% Rounded minimum total cost to one decimal place
% Since cost10 is cost*10 exactly, printing cost10/10.0 gives one decimal.
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_cost=", show(cost10), "/10 = ", show_float(cost10 / 10.0), "\n"
];