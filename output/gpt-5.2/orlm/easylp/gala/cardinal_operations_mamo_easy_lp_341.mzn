% Transportation resource allocation - minimize total cost
% All data embedded as requested.

int: max_x1 = 60;
int: max_x2 = 50;
int: max_x3 = 150;
int: max_x4 = 90;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Operational constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 <= 200;
constraint x1 + x3 >= 50;
constraint x2 + x4 >= 80;

% Objective: minimize total cost
var int: total_cost = 5*x1 + 10*x2 + 7*x3 + 8*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];