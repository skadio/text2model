% Parameters
int: max_XY = 150;
int: min_XZ = 100;
int: max_diff_YZ = 60;
int: max_Z_minus_X = 10;

int: costX = 50;
int: costY = 80;
int: costZ = 30;

% Variables
var 0..150: X;
var 0..150: Y;
var 0..150: Z;

var 0..(costX*150 + costY*150 + costZ*150): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;

constraint Y - Z <= max_diff_YZ;
constraint Z - Y <= max_diff_YZ;

constraint Z - X <= max_Z_minus_X;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;