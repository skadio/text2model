% Energy investment allocation: minimize total cost under linear constraints.
include "globals.mzn";

% Decision variables (integers, non-negative investments)
var 0..5000: X;
var 0..5000: Y;
var 0..5000: Z;

% Budget constraint
constraint X + Y + Z <= 5000;

% Viability / requirement constraints
% "Project X requires a minimum investment of 2000 units more than negative three times Y"
constraint X >= 2000 - 3 * Y;

% "Project Z requires at least 1000 units more than Y"
constraint Z >= Y + 1000;

% Objective: minimize total cost/return coefficients
var 0..(20*5000 + 15*5000 + 30*5000): total_cost;
constraint total_cost = 20 * X + 15 * Y + 30 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (nearest whole number) = ", show(total_cost), "\n"
];