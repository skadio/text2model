% Parameters (with values embedded)
float: c1 = 0.5;
float: c2 = 0.2;
float: c3 = 3.0;
float: c4 = 1.5;

int: x1_min = 50;  int: x1_max = 150;
int: x2_min = 80;  int: x2_max = 120;
int: x3_min = 20;  int: x3_max = 70;
int: x4_min = 30;  int: x4_max = 60;

int: cap12 = 200;
int: cap34 = 180;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var float: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% 0.7*x1 - x3 >= 0  ->  7*x1 - 10*x3 >= 0
constraint 7 * x1 - 10 * x3 >= 0;

% 0.5*x2 - x4 >= 0  ->  x2 - 2*x4 >= 0
constraint x2 - 2 * x4 >= 0;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(round(total_cost)), "\n"
];