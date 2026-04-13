include "globals.mzn";

% Data (embedded as requested)
int: max_total = 200;

int: minX = 50;
int: minY = 30;
int: minZ = 20;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Decision variables: whole-number staffing levels
var minX..max_total: X;
var minY..max_total: Y;
var minZ..max_total: Z;

% Total staffing limit
constraint X + Y + Z <= max_total;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = $", show(total_cost), "\n"
];