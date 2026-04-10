% Parameters
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;

int: roi_X = 2;
int: roi_Y = 3;
int: roi_Z = 5;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_YZ: Z;

var 0..(max_XY + max_YZ): total_cost = X + Y + Z;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;

% Objective
solve minimize total_cost;