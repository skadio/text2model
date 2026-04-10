% Parameters (with values embedded)
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

int: max12 = 500;
int: max34 = 400;
int: min13 = 350;
int: min24 = 300;

% Variables
var 0..max12: x1;
var 0..max12: x2;
var 0..max34: x3;
var 0..max34: x4;

var 0..(c1*max12 + c2*max12 + c3*max34 + c4*max34): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];