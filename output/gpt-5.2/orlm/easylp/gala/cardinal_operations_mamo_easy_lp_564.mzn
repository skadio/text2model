include "globals.mzn";

% Data (embedded as required)
int: BUDGET = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 200;

% Decision variables: whole-number funding amounts
var minX..BUDGET: X;
var minY..BUDGET: Y;
var minZ..BUDGET: Z;

% Total funding cannot exceed budget
constraint X + Y + Z <= BUDGET;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];