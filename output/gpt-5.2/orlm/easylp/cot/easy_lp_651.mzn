% Parameters (with values embedded)
int: c1 = 500;
int: c2 = 300;
int: c3 = 200;
int: c4 = 100;

int: max12 = 50;
int: max34 = 70;

% Variables
var 0..50: x1;
var 0..50: x2;
var 0..70: x3;
var 0..70: x4;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

% ROI constraint:
% 0.5*x1 - 0.25*x2 + 0.15*x3 + 1*x4 >= 20
% Multiply by 20 to keep integers: 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400
constraint 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400;

% Risk/difference constraint:
% 2.5*x2 + 0.75*x3 - x1 - x4 <= 30
% Multiply by 4: 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120
constraint 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];