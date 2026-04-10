% Hiring optimization: minimize total salary cost with minimum hires and total cap

int: max_total_hires = 100;

int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

int: salary_X = 50000;
int: salary_Y = 70000;
int: salary_Z = 90000;

var int: X;
var int: Y;
var int: Z;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= max_total_hires;

var int: total_cost = salary_X * X + salary_Y * Y + salary_Z * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];