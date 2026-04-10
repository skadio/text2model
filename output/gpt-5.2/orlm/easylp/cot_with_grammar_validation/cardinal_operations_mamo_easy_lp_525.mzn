% Parameters
int: max_XY = 150;
int: min_XZ = 100;
int: max_diff_YZ = 60;
int: max_Z_minus_X = 10;

int: cost_X = 50;
int: cost_Y = 80;
int: cost_Z = 30;

% Variables
var 0..150: X;
var 0..150: Y;
var 0..150: Z;

var 0..(cost_X*150 + cost_Y*150 + cost_Z*150): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint abs(Y - Z) <= max_diff_YZ;
constraint X >= Z - max_Z_minus_X;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;