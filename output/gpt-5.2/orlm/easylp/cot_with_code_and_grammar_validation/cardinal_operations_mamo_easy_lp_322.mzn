% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: max_XY = 20;
int: min_YZ = 30;
int: max_diff_XZ = 10;

% Upper bounds derived from constraints:
% X <= max_XY, Y <= max_XY, Z <= min_YZ + max_diff_XZ (since Y can be 0, then Z>=30 and X<=10 => Z-X<=10 => Z<=40)
int: ubX = max_XY;
int: ubY = max_XY;
int: ubZ = min_YZ + max_diff_XZ;

% Variables
var 0..ubX: X;
var 0..ubY: Y;
var 0..ubZ: Z;

var 0..(costX*ubX + costY*ubY + costZ*ubZ): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z >= min_YZ;

constraint abs(X - Z) <= max_diff_XZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;