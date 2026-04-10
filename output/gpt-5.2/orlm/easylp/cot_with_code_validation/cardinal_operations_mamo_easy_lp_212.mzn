% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: min_XY = 50;
int: max_XZ = 100;
int: min_Y_minus_Z = 10;

% Variables
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint X + Y >= min_XY;
constraint X + Z <= max_XZ;
constraint Y - Z >= min_Y_minus_Z;

% Objective
solve minimize costX * X + costY * Y + costZ * Z;