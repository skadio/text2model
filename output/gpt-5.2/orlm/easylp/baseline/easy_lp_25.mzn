% Transportation company vehicle operation cost minimization

int: costX = 5;
int: costY = 10;

int: minX = 30;
int: minY = 20;
int: maxTotal = 100;

var minX..maxTotal: X;
var minY..maxTotal: Y;

constraint X + Y <= maxTotal;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total vehicles = ", show(X + Y), "\n",
  "Minimum daily operational cost = $", show(totalCost), "\n"
];