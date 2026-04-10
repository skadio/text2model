% Hiring optimization: minimize salary cost with integer headcounts

int: salaryX = 5000;
int: salaryY = 3000;

int: maxTotal = 50;
int: minX = 20;
int: maxY = 15;

var 0..maxTotal: x; % employees in position X
var 0..maxTotal: y; % employees in position Y

constraint x + y <= maxTotal;
constraint x >= minX;
constraint y <= maxY;

var int: total_cost = salaryX * x + salaryY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "minimum_total_salary_cost=$", show(total_cost), "\n"
];