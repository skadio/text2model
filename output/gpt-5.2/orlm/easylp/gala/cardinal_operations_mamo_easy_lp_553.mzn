% Hiring optimization (all data embedded)

int: maxTotal = 100;

int: minX = 30;
int: minY = 20;
int: minZ = 10;

int: salaryX = 5000;
int: salaryY = 4000;
int: salaryZ = 6000;

% Decision variables: number of hires (must be whole numbers)
var minX..maxTotal: x;
var minY..maxTotal: y;
var minZ..maxTotal: z;

% Total headcount limit
constraint x + y + z <= maxTotal;

% Objective: minimize total salary cost
var int: totalCost = salaryX * x + salaryY * y + salaryZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum total salary cost = $", show(totalCost), "\n"
];