% Parameters
int: max_XY = 1000;
int: min_YZ = 500;
int: max_diff_XZ = 200;

int: costX = 4;
int: costY = 3;
int: costZ = 2;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

var 0..(costX*1000 + costY*1000 + costZ*1000): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z >= min_YZ;
constraint abs(X - Z) <= max_diff_XZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;