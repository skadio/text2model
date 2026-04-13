% Parameters (with values embedded)
int: max_units = 150;
int: strength_X_coeff = 3;
int: strength_Y_coeff = 4;
int: min_strength = 100;

int: diff_ZX_max = 30;
int: Y_minus_Z_min = 20;

int: cost_X = 10000;
int: cost_Y = 2000;
int: cost_Z = 500;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(max_units * max([cost_X, cost_Y, cost_Z])): total_support;

% Constraints
constraint X + Y + Z <= max_units;

constraint strength_X_coeff * X + strength_Y_coeff * Y >= min_strength;

constraint abs(Z - X) <= diff_ZX_max;

constraint Y - Z >= Y_minus_Z_min;

constraint total_support = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_support;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_support_points=", show(total_support), "\n"
];