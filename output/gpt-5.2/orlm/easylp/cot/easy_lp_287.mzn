% Parameters (with values embedded)
int: BUDGET_MAX = 300;

int: minX = 80;
int: minY = 60;
int: minZ = 40;

int: costX = 50;
int: costY = 70;
int: costZ = 100;

% Variables
var minX..BUDGET_MAX: X;
var minY..BUDGET_MAX: Y;
var minZ..BUDGET_MAX: Z;

var 0..(costX*BUDGET_MAX + costY*BUDGET_MAX + costZ*BUDGET_MAX): TotalCost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

constraint TotalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize TotalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (nearest whole number) = ", show(TotalCost), "\n"
];