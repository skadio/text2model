include "globals.mzn";

% Data (embedded as required)
int: BUDGET = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: maxX_over_Y = 50;
int: minY_over_Z = 20;

int: costX = 300;
int: costY = 500;
int: costZ = 200;

% Decision variables (whole-number allocations)
var minX..BUDGET: X;
var minY..BUDGET: Y;
var minZ..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X - Y <= maxX_over_Y;     % X should not exceed Y by more than 50
constraint Y >= Z + minY_over_Z;     % Y at least 20 more than Z

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];