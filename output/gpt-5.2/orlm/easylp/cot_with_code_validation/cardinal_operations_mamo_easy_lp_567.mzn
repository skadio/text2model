% Parameters
int: total_budget = 1000;
int: min_diff_XY = 200;          % X >= Y + 200
int: max_abs_diff_ZX = 300;      % |Z - X| <= 300
int: min_sum_YZ = 500;           % Y + Z >= 500

int: impact_X = 2;
int: impact_Y = 3;
int: impact_Z = 4;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(impact_X*total_budget + impact_Y*total_budget + impact_Z*total_budget): total_impact;

% Constraints
constraint X + Y + Z <= total_budget;
constraint X >= Y + min_diff_XY;
constraint abs(Z - X) <= max_abs_diff_ZX;
constraint Y + Z >= min_sum_YZ;

constraint total_impact = impact_X * X + impact_Y * Y + impact_Z * Z;

% Objective
solve minimize total_impact;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total impact points = ", show(total_impact), "\n"
];