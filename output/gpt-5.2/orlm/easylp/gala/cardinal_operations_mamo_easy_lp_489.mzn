% Military resource allocation (integer linear program)
% All data embedded as required.

int: maxX = 20;
int: maxY = 15;

int: a1 = 10;  int: b1 = 15;  int: rhs1 = 100;   % a1*X + b1*Y >= rhs1
int: a2 = 20;  int: b2 = 30;  int: rhs2 = 200;   % a2*X + b2*Y <= rhs2

int: minDiff = 10;                               % X >= Y + 10

int: costX = 5000;
int: costY = 7000;

var 0..maxX: X;
var 0..maxY: Y;

constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;
constraint X >= Y + minDiff;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];