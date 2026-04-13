% Parameters (with values embedded)
int: min_effort = 100;
int: max_limit = 200;
int: max_diff_xz = 50;

int: costX = 5;
int: costY = 6;
int: costZ = 4;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

var 0..100000: total_support;

% Constraints
constraint X + 2*Y + Z >= min_effort;
constraint 2*X + Y <= max_limit;
constraint X - Z <= max_diff_xz;
constraint Z - X <= max_diff_xz;

constraint total_support = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];