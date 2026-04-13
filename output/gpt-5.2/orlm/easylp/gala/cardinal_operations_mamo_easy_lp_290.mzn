% Resource allocation among three departments X, Y, Z
% Minimize total cost subject to linear constraints and integrality.

include "globals.mzn";

% Decision variables (nonnegative integers)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y + Z >= 50;
constraint 4 * X - Y <= 30;
constraint Z - 2 * Y >= 10;

% Objective: minimize cost
var 0..1000000: total_cost = 5 * X + 3 * Y + 2 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];