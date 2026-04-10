include "globals.mzn";

% Decision variables: integer number of units for each property type
var 0..20: x1; % residential
var 0..30: x2; % commercial
var 0..15: x3; % industrial
var 0..10: x4; % retail

% Constraints
constraint x1 + x2 <= 50;
constraint 2 * x3 + x4 >= 60;

% Handle fractional coefficients by scaling by 2
% 3*x1 + 4.5*x2 <= 100  <=>  6*x1 + 9*x2 <= 200
constraint 6 * x1 + 9 * x2 <= 200;

% 6*x3 - 0.5*x4 <= 80  <=>  12*x3 - x4 <= 160
constraint 12 * x3 - x4 <= 160;

% Objective: minimize total investment cost
var int: total_cost = 200000 * x1 + 300000 * x2 + 500000 * x3 + 700000 * x4;

solve minimize total_cost;

output [
  "x1(residential) = ", show(x1), "\n",
  "x2(commercial)  = ", show(x2), "\n",
  "x3(industrial)  = ", show(x3), "\n",
  "x4(retail)      = ", show(x4), "\n",
  "total_cost($)   = ", show(total_cost), "\n"
];