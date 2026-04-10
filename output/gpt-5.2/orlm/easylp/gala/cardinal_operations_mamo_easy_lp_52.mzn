% Retail ordering: minimize total cost with storage and minimum order constraints

int: costX = 2;
int: costY = 3;

int: maxUnits = 1000;
int: minX = 200;
int: minY = 300;

var minX..maxUnits: x;   % units of product X
var minY..maxUnits: y;   % units of product Y

constraint x + y <= maxUnits;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = $", show(totalCost), "\n",
  "roundedCost = $", show(totalCost), "\n"  % already integer dollars
];