% Parameters (with values embedded)
int: total_budget_limit = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 500;

int: costX = 10;
int: costY = 8;
int: costZ = 6;

% Variables
var minX..total_budget_limit: X;
var minY..total_budget_limit: Y;
var minZ..total_budget_limit: Z;

var 0..(costX*total_budget_limit + costY*total_budget_limit + costZ*total_budget_limit): total_expenditure;

% Constraints
constraint X + Y + Z <= total_budget_limit;

constraint total_expenditure = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_expenditure;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total expenditure = ", show(total_expenditure), "\n"
];