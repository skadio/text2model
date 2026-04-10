% Parameters
float: c1 = 0.5;
float: c2 = 0.3;
float: c3 = 0.4;
float: c4 = 0.6;

int: x1_min = 0;   int: x1_max = 400;
int: x2_min = 0;   int: x2_max = 300;
int: x3_min = 50;  int: x3_max = 200;
int: x4_min = 30;  int: x4_max = 60;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var float: total_cost;
var int: rounded_cost;

% Constraints
constraint x1 + x2 <= 500;
constraint 2 * x1 + 3 * x3 >= 300;
constraint x4 <= (x2 div 2) + 100;
constraint x2 + x4 - x1 - x3 = 80;

constraint total_cost = c1 * int2float(x1)
                      + c2 * int2float(x2)
                      + c3 * int2float(x3)
                      + c4 * int2float(x4);

% round to nearest integer (0.5 rounds up)
constraint rounded_cost = floor(total_cost + 0.5);

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_cost=", show(rounded_cost), "\n"
];