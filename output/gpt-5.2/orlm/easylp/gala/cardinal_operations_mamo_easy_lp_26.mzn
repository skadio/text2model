% Transportation trucks cost minimization (all data embedded)

int: minX = 300;
int: minY = 200;
int: maxTotal = 1000;

int: costX = 2;
int: costY = 3;

var minX..maxTotal: X;
var minY..maxTotal: Y;

constraint X + Y <= maxTotal;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];