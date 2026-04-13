% Transportation capacity allocation among three routes (X, Y, Z)
% Minimize total cost subject to capacity and minimum-allocation constraints.

include "globals.mzn";

% Data (embedded from the problem description)
int: total_cap_max = 500;

int: X_min = 100; int: X_max = 300; int: X_cost = 5;
int: Y_min = 150; int: Y_max = 400; int: Y_cost = 10;
int: Z_min = 200; int: Z_max = 600; int: Z_cost = 15;

% Decision variables (whole-number allocations)
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

% Constraints
constraint X + Y + Z <= total_cap_max;

% Objective: minimize total cost
var int: total_cost = X_cost * X + Y_cost * Y + Z_cost * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost = ", show(total_cost), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];