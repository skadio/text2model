% Hiring optimization: minimize total monthly salary cost

int: salaryX = 5000;
int: salaryY = 8000;

int: maxTotalHires = 100;
int: minX = 20;
int: minY = 30;

var int: x; % number hired for position X
var int: y; % number hired for position Y

constraint x >= minX;
constraint y >= minY;
constraint x + y <= maxTotalHires;

var int: totalCost = salaryX * x + salaryY * y;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "totalCost=", show(totalCost), "\n"
];