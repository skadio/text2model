% Parameters
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;
int: max_diff_XY = 200;

int: costX = 20;
int: costY = 30;
int: costZ = 10;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_YZ: Z;

var 0..(costX*max_XY + costY*max_XY + costZ*max_YZ): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;

constraint abs(X - Y) <= max_diff_XY;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;