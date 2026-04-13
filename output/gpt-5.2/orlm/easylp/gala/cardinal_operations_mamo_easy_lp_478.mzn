% Budget allocation between two programs (integer students), minimize total cost.

int: costX = 500;
int: costY = 300;

int: maxTotal = 25;
int: minX = 10;
int: minY = 5;

var minX..maxTotal: x;   % students in Program X
var minY..maxTotal: y;   % students in Program Y

constraint x + y <= maxTotal;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "Program X students = ", show(x), "\n",
  "Program Y students = ", show(y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];