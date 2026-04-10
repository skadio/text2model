% Military resource allocation: minimize support points
include "globals.mzn";

% Parameters (embedded from problem description)
int: max_units = 10000;
int: min_strength = 7000;
int: max_imbalance = 2000;

int: costX = 5000;
int: costY = 3000;

% Decision variables: whole numbers of units
var 0..max_units: X;
var 0..max_units: Y;

% Constraints
constraint X + Y <= max_units;
constraint 2 * X + Y >= min_strength;
constraint X - 2 * Y <= max_imbalance;

% Objective: total support points
var 0..(costX * max_units + costY * max_units): total_support;
constraint total_support = costX * X + costY * Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points = ", show(total_support), "\n"
];