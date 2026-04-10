% Parameters
int: max_XY = 100;
int: min_XZ = 50;
int: max_diff_YZ = 20;

int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_XY: Z;

var 0..(costX*max_XY + costY*max_XY + costZ*max_XY): total_effort;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint abs(Y - Z) <= max_diff_YZ;

constraint total_effort = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_effort;