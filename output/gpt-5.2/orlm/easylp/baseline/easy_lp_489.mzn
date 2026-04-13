% Resource allocation between units X and Y
% All data embedded directly in the model.

int: maxX = 20;
int: maxY = 15;

int: a1 = 10;  % metric 1 coefficient for X
int: b1 = 15;  % metric 1 coefficient for Y
int: rhs1 = 100;

int: a2 = 20;  % metric 2 coefficient for X
int: b2 = 30;  % metric 2 coefficient for Y
int: rhs2 = 200;

int: costX = 5000;
int: costY = 7000;

var 0..maxX: X;
var 0..maxY: Y;

constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;
constraint X >= Y + 10;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];