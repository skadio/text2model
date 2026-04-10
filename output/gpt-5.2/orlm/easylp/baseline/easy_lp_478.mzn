% Budget allocation between two programs: minimize total cost

int: costX = 500;
int: costY = 300;

int: maxTotalStudents = 25;
int: minX = 10;
int: minY = 5;

var int: x; % students in Program X
var int: y; % students in Program Y

constraint x >= minX;
constraint y >= minY;
constraint x + y <= maxTotalStudents;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "Program X students = ", show(x), "\n",
  "Program Y students = ", show(y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];