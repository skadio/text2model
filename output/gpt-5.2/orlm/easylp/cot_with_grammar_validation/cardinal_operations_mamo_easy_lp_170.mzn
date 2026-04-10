% Parameters
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;

int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_YZ: Z;

var 0..(costX*max_XY + costY*max_XY + costZ*max_YZ): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;