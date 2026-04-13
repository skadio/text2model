% Resource allocation for four construction tasks
% Minimize total cost subject to linear constraints

int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

% Bounds (not explicitly given in the description, so use nonnegative integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Constraints
constraint x1 + x2 <= 30;
constraint 2*x1 + x3 >= 40;
constraint x4 - x2 = 20;

% x1 + 0.5*x3 >= 10  =>  2*x1 + x3 >= 20
constraint 2*x1 + x3 >= 20;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];