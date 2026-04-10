% Hiring optimization (all data embedded)

int: salaryX = 5000;
int: salaryY = 8000;

int: maxTotal = 100;
int: minX = 20;
int: minY = 30;

var minX..maxTotal: x;   % hires for position X
var minY..maxTotal: y;   % hires for position Y

constraint x + y <= maxTotal;

var int: totalCost = salaryX * x + salaryY * y;

solve minimize totalCost;

output [
  "x (Position X hires) = ", show(x), "\n",
  "y (Position Y hires) = ", show(y), "\n",
  "Minimum total monthly salary cost = $", show(totalCost), "\n"
];