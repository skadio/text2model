include "globals.mzn";

% Decision variables: number of projects of each type (nonnegative integers)
var 0..20: X;  % residential
var 0..20: Y;  % commercial
var 0..20: Z;  % infrastructure

% Capacity constraint
constraint X + Y + Z <= 20;

% Portfolio diversity: X + 0.5*Y >= 5  <=>  2*X + Y >= 10
constraint 2 * X + Y >= 10;

% Expertise constraint: Y + Z <= 10
constraint Y + Z <= 10;

% Objective: minimize total cost
var int: total_cost = 1000 * X + 2000 * Y + 1500 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];