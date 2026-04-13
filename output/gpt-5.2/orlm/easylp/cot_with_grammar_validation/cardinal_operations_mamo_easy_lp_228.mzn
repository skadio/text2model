% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint 2 * X + 3 * Y + Z >= 10;
constraint X - Y + Z <= 8;
constraint Y - Z >= 3;

% Objective
solve minimize costX * X + costY * Y + costZ * Z;