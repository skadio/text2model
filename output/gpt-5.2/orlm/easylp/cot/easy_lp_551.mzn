% Parameters (with values embedded)
int: total_employees_max = 1000;
int: cost_X = 50;
int: cost_Y = 60;
int: cost_Z = 70;

int: cap_X = 500;
int: cap_Y = 400;
int: cap_Z = 300;

int: diff_XY = 200;
int: diff_YZ = 100;

% Variables
var 0..cap_X: X;
var 0..cap_Y: Y;
var 0..cap_Z: Z;

var 0..(cost_X*cap_X + cost_Y*cap_Y + cost_Z*cap_Z): total_cost;

% Constraints
constraint X + Y + Z <= total_employees_max;

constraint X >= Y + diff_XY;
constraint Y >= Z + diff_YZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];