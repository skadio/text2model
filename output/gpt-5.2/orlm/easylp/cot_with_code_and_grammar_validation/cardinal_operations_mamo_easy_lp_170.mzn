% Parameters
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;

int: cX = 5;
int: cY = 4;
int: cZ = 3;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_YZ: Z;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;

% Objective
solve minimize cX * X + cY * Y + cZ * Z;