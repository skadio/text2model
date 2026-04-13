int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

% Bounds (not explicitly provided in the description; choose wide nonnegative bounds)
int: U = 100000;

var 0..U: x1;
var 0..U: x2;
var 0..U: x3;
var 0..U: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 1200;

% x1 >= (4/3) * x3  <=> 3*x1 >= 4*x3
constraint 3 * x1 >= 4 * x3;

% x2 >= (9/7)*x4 + 200  <=> 7*x2 >= 9*x4 + 1400
constraint 7 * x2 >= 9 * x4 + 1400;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];