include "globals.mzn";

% Embedded data (from description)
int: max_units = 1000;
int: min_2x_plus_y = 200;
int: max_diff_xz = 50;
int: min_y_plus_z = 400;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Decision variables: allocations are whole numbers
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

% Total supported units limit
constraint X + Y + Z <= max_units;

% Operational constraints
constraint 2*X + Y >= min_2x_plus_y;
constraint abs(X - Z) <= max_diff_xz;
constraint Y + Z >= min_y_plus_z;

% Objective: minimize total support points
var 0..(max_units * max(costX, max(costY, costZ))): total_support;
constraint total_support = costX*X + costY*Y + costZ*Z;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalSupport = ", show(total_support), "\n"
];