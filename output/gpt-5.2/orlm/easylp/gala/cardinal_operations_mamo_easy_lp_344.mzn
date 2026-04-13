include "globals.mzn";

% Decision variables: integer investment units
var 0..1000: x1;
var 0..1000: x2;
var 0..500:  x3;
var 0..500:  x4;

% ---- Constraints ----

% Budget cap for X1 and X2
constraint x1 + x2 <= 1000;

% Profitability for X1 and X2: 0.05*x1 + 0.07*x2 >= 50
% Multiply by 100 to keep integers: 5*x1 + 7*x2 >= 5000
constraint 5*x1 + 7*x2 >= 5000;

% Budget cap for X3 and X4
constraint x3 + x4 <= 500;

% Net loss constraint for X3 and X4:
% -0.03*x3 -0.04*x4 <= -20  <=> 0.03*x3 + 0.04*x4 >= 20
% Multiply by 100: 3*x3 + 4*x4 >= 2000
constraint 3*x3 + 4*x4 >= 2000;

% Objective: minimize total cost
var int: total_cost = 10*x1 + 15*x2 + 20*x3 + 25*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];