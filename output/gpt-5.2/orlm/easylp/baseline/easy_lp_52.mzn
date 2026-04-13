% Retail ordering problem: minimize total cost of products X and Y

int: costX = 2;
int: costY = 3;

int: maxTotalUnits = 1000;
int: minX = 200;
int: minY = 300;

var int: X;
var int: Y;

constraint X >= minX;
constraint Y >= minY;
constraint X + Y <= maxTotalUnits;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (nearest dollar) = $", show(totalCost), "\n"
];