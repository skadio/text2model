% Shipping containers optimization (all data embedded)

int: costX = 50;
int: costY = 70;

int: maxTotal = 1000;
int: minX = 300;
int: minY = 200;

var minX..maxTotal: x;  % number of type X containers
var minY..maxTotal: y;  % number of type Y containers

constraint x + y <= maxTotal;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "totalCost=", show(totalCost), "\n"
];