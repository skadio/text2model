include "globals.mzn";

% Data (embedded from the description)
int: max_total_units = 100;
int: strength_req = 50;
int: max_diff_ZY = 30;

int: costX = 500;
int: costY = 600;
int: costZ = 700;

% Decision variables: number of units of each type (integers)
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

% Constraints
constraint X + Y + Z <= max_total_units;
constraint 5 * X + 3 * Y >= strength_req;
constraint abs(Z - Y) <= max_diff_ZY;

% Objective: minimize total support points
var 0..(max_total_units * max([costX, costY, costZ])): total_support;
constraint total_support = costX * X + costY * Y + costZ * Z;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total support points = ", show(total_support), "\n"
];