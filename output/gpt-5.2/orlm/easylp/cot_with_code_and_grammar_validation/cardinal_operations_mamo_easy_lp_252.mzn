% Parameters
int: max_XY = 1000;
int: min_YZ = 500;
int: max_diff_XZ = 200;

int: cost_X = 4;
int: cost_Y = 3;
int: cost_Z = 2;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

var 0..(cost_X*1000 + cost_Y*1000 + cost_Z*1000): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z >= min_YZ;

constraint X - Z <= max_diff_XZ;
constraint Z - X <= max_diff_XZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;