% Parameters
int: cap_XY = 30;
int: cap_YZ = 20;
int: min_XZ = 10;

int: cost_X = 5;
int: cost_Y = 3;
int: cost_Z = 1;

% Variables
var 0..cap_XY: X;
var 0..max(cap_XY, min_XZ): Z;
var 0..min(cap_XY, cap_YZ): Y;

var 0..(cost_X*cap_XY + cost_Y*min(cap_XY,cap_YZ) + cost_Z*max(cap_XY,min_XZ)): total_cost;

% Constraints
constraint X + Y <= cap_XY;
constraint Y + Z <= cap_YZ;
constraint X + Z >= min_XZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;