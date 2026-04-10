include "globals.mzn";

/* Data (embedded from problem description) */
int: max_total_units = 150;
int: min_strength = 100;
int: max_diff_zx = 30;
int: min_y_minus_z = 20;

int: strength_x_coeff = 3;
int: strength_y_coeff = 4;

int: cost_x = 10000;
int: cost_y = 2000;
int: cost_z = 500;

/* Decision variables: numbers of units */
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

/* Constraints */
constraint X + Y + Z <= max_total_units;
constraint strength_x_coeff * X + strength_y_coeff * Y >= min_strength;
constraint abs(Z - X) <= max_diff_zx;
constraint Y >= Z + min_y_minus_z;

/* Objective: minimize total support points */
var int: total_support =
  cost_x * X + cost_y * Y + cost_z * Z;

solve minimize total_support;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total support points = ", show(total_support), "\n"
];