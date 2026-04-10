% Parameters
int: Budget = 1000;
int: min_diff_XY = 100;
int: min_diff_YZ = 50;
int: retX = 10;
int: retY = 15;
int: retZ = 20;

% Variables
var 0..Budget: X;
var 0..Budget: Y;
var 0..Budget: Z;
var 0..(retX*Budget + retY*Budget + retZ*Budget): total_return;

% Constraints
constraint X + Y + Z <= Budget;
constraint X >= Y + min_diff_XY;
constraint Y >= Z + min_diff_YZ;

constraint total_return = retX * X + retY * Y + retZ * Z;

% Objective
solve minimize total_return;