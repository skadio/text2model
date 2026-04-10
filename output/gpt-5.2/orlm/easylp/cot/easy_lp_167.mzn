% Parameters (with values embedded)
int: total_budget = 1000;
int: min_diff_XY = 100;
int: min_diff_YZ = 50;

int: return_X = 10;
int: return_Y = 15;
int: return_Z = 20;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(return_X*total_budget + return_Y*total_budget + return_Z*total_budget): total_return;

% Constraints
constraint X + Y + Z <= total_budget;
constraint X >= Y + min_diff_XY;
constraint Y >= Z + min_diff_YZ;

constraint total_return = return_X*X + return_Y*Y + return_Z*Z;

% Objective
solve minimize total_return;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total return (units) = ", show(total_return), "\n"
];