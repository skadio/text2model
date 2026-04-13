% Financial planning: minimize total cost under budget and bounds.
include "globals.mzn";

% Decision variables: integer dollars invested in each option
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y + Z <= 1000;
constraint X >= 300;
constraint Y <= 500;
constraint Z >= 200;

% Objective: total cost/return coefficient per dollar invested
var int: total_cost = 10*X + 15*Y + 20*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];