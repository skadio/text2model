% Parameters (with values embedded)
int: max_XY = 1000;
int: min_YZ = 500;
int: max_abs_XZ = 200;

int: costX = 4;
int: costY = 3;
int: costZ = 2;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_XY: Z;

var 0..(costX*max_XY + costY*max_XY + costZ*max_XY): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z >= min_YZ;
constraint abs(X - Z) <= max_abs_XZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;