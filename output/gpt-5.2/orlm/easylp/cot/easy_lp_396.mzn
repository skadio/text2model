% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max_x1_x2 = 1000;
int: min_2x3_x4 = 500;
int: max_x1_3x4 = 1200;
int: max_x2_minus_2x3 = 300;

% Variables
var 0..1200: x1;
var 0..1000: x2;
var 0..250: x3;      % From 2*x3 + x4 >= 500 with x4 >= 0 and x4 <= 400 (below)
var 0..400: x4;      % From x1 + 3*x4 <= 1200 with x1 >= 0

var int: total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint 2*x3 + x4 >= min_2x3_x4;
constraint x1 + 3*x4 <= max_x1_3x4;
constraint x2 - 2*x3 <= max_x2_minus_2x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];