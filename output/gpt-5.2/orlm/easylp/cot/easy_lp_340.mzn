% Parameters (with values embedded)
int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 4;
int: cost4 = 5;

int: max12 = 100;
int: max34 = 200;
int: min13 = 50;
int: min24 = 150;

% Variables
var 0..max12: x1;
var 0..max12: x2;
var 0..max34: x3;
var 0..max34: x4;

var 0..(cost1*max12 + cost2*max12 + cost3*max34 + cost4*max34): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];