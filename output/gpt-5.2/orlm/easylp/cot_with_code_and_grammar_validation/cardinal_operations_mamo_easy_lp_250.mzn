% Parameters
int: timeX = 1;
int: timeY = 2;
int: timeZ = 3;

% Variables
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint 2 * X * timeX + Y * timeY <= 6;
constraint X * timeX + Z * timeZ <= 5;
constraint Y * timeY + Z * timeZ >= 7;

% Objective
solve minimize X * timeX + Y * timeY + Z * timeZ;