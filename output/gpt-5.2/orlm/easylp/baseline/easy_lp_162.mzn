int: costX = 200000;
int: costY = 300000;
int: maxTotal = 10;

var 1..maxTotal: x; % properties at location X (at least 1)
var 1..maxTotal: y; % properties at location Y (at least 1)

constraint x + y <= maxTotal;
constraint x >= 3 * y;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "totalCost=$", show(totalCost), "\n"
];