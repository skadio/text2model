% Budget allocation across departments X, Y, Z
% Minimize total expenditure subject to minimum budgets and total budget cap.

int: total_budget_cap = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 500;

int: costX = 10;
int: costY = 8;
int: costZ = 6;

var int: x; % budget allocated to X
var int: y; % budget allocated to Y
var int: z; % budget allocated to Z

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= total_budget_cap;

var int: total_expenditure = costX * x + costY * y + costZ * z;

solve minimize total_expenditure;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_expenditure = ", show(total_expenditure), "\n"
];