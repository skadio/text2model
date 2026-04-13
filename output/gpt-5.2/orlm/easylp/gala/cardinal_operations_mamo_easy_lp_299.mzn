% Fund allocation to projects X, Y, Z
% Minimize total cost subject to linear constraints (integer allocations)

include "globals.mzn";

% Data (embedded as requested)
int: max_total = 1000;
int: costX = 5;
int: costY = 2;
int: costZ = 3;

% Decision variables: whole-number allocations
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

% Constraints
constraint X + Y + Z <= max_total;
constraint X - Y >= 10;
constraint Z - Y <= 20;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];