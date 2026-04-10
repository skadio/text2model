include "globals.mzn";

% Decision variables: whole-number resources allocated to initiatives X, Y, Z
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint X + Y + Z <= 100;
constraint 2 * Y + Z >= 50;
constraint X + Z <= 80;

% Objective: minimize total cost (2 per unit of X, 3 per unit of Y, 1 per unit of Z)
var 0..1000: total_cost = 2 * X + 3 * Y + 1 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];