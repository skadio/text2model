% Parameters (with values embedded)
int: min_XY = 1000;
int: max_diff_YZ = 500;
int: sum_XZ = 1500;

int: costX = 8;
int: costY = 5;
int: costZ = 2;

% Variables
var 0..sum_XZ: X;
var 0..100000: Y;
var 0..sum_XZ: Z;

% Constraints
constraint X + Y >= min_XY;
constraint abs(Y - Z) <= max_diff_YZ;
constraint X + Z == sum_XZ;

% Objective
var 0..intmax: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];