% Hiring optimization: minimize total salary cost with headcount requirements.

int: max_total = 100;

int: minX = 30;
int: minY = 20;
int: minZ = 10;

int: salaryX = 5000;
int: salaryY = 4000;
int: salaryZ = 6000;

var int: x >= minX;
var int: y >= minY;
var int: z >= minZ;

constraint x + y + z <= max_total;

var int: total_cost = salaryX * x + salaryY * y + salaryZ * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_salary_cost=", show(total_cost), "\n"
];