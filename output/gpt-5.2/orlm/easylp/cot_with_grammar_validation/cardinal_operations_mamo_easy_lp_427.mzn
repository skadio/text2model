% Parameters
int: capacity = 500;
int: minX = 200;
int: minY = 100;

float: costX = 0.05;
float: costY = 0.1;

% Variables
var minX..capacity: x;
var minY..capacity: y;

var float: total_cost;
var float: total_cost_rounded_1dp;

% Constraints
constraint x + y <= capacity;

constraint total_cost = costX * int2float(x) + costY * int2float(y);

constraint total_cost_rounded_1dp = int2float(round(total_cost * 10.0)) / 10.0;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n",
  "total_cost_rounded_1dp=", show(total_cost_rounded_1dp), "\n"
];