% Staff allocation across four projects with linear cost minimization

% Decision variables (integers within given bounds)
var 0..25: x1;
var 0..25: x2;
var 0..35: x3;
var 0..35: x4;

% Capacity constraints
constraint x1 + x2 <= 40;
constraint x3 + x4 <= 60;

% Minimum staffing constraints
constraint x1 + x3 >= 20;
constraint x2 + x4 >= 30;

% Objective: minimize total cost
var int: total_cost = 50*x1 + 80*x2 + 30*x3 + 70*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];