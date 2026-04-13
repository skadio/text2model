% Parameters
int: x1_min = 50;
int: x1_max = 150;
int: x2_min = 80;
int: x2_max = 120;
int: x3_min = 20;
int: x3_max = 70;
int: x4_min = 30;
int: x4_max = 60;

int: cap12 = 200;
int: cap34 = 180;

% Costs as scaled integers (multiply all costs by 10 to avoid floats)
% 0.5 -> 5, 0.2 -> 2, 3 -> 30, 1.5 -> 15
int: c1 = 5;
int: c2 = 2;
int: c3 = 30;
int: c4 = 15;
int: scale = 10;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost_scaled;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% 0.7*x1 - x3 >= 0  <=>  7*x1 - 10*x3 >= 0
constraint 7 * x1 - 10 * x3 >= 0;

% 0.5*x2 - x4 >= 0  <=>  x2 - 2*x4 >= 0
constraint x2 - 2 * x4 >= 0;

constraint total_cost_scaled = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost_scaled;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost_scaled=", show(total_cost_scaled), "\n",
  "total_cost_rounded=", show((total_cost_scaled + scale div 2) div scale), "\n"
];