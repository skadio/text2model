include "globals.mzn";

/* Data (embedded as required) */
int: min_effort = 100;
int: max_effort = 200;
int: max_diff_xz = 50;

int: costX = 5;
int: costY = 6;
int: costZ = 4;

/* Decision variables (whole numbers) */
var 0..200: X;
var 0..200: Y;
var 0..200: Z;

/* Constraints */
constraint X + 2*Y + Z >= min_effort;
constraint 2*X + Y <= max_effort;
constraint abs(X - Z) <= max_diff_xz;

/* Objective: minimize total support points */
var int: total_support = costX*X + costY*Y + costZ*Z;

solve minimize total_support;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total support points = ", show(total_support), "\n"
];