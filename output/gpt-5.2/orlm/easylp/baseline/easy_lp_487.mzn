int: costX = 20;
int: costY = 30;

int: maxTotal = 1000;
int: minDiff = 200;
int: max2XplusY = 1500;

int: maxX = 800;
int: maxY = 600;

var 0..maxX: x;
var 0..maxY: y;

constraint x + y <= maxTotal;
constraint abs(x - y) >= minDiff;
constraint 2*x + y <= max2XplusY;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];