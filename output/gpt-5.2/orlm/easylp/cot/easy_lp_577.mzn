% Parameters (with values embedded)
int: max_X = 100;
int: max_Y = 120;
int: max_Z = 90;

int: cap_XY = 200;
int: min_YZ = 150;
int: diff_XZ = 30;

int: cost_X = 5;
int: cost_Y = 4;
int: cost_Z = 3;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint X + Y <= cap_XY;
constraint Y + Z >= min_YZ;
constraint X - Z = diff_XZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];