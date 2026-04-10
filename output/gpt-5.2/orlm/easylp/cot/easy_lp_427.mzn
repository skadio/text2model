% Parameters (with values embedded)
int: capacity = 500;
int: minX = 200;
int: minY = 100;
float: costX = 0.05;
float: costY = 0.1;

% Variables
var minX..capacity: X;
var minY..capacity: Y;
var float: total_cost;

% Constraints
constraint X + Y <= capacity;
constraint total_cost = costX * int2float(X) + costY * int2float(Y);

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show_float(1, total_cost), "\n"
];