% Parameters
int: max_XY = 100;
int: max_XZ = 80;
int: min_YZ = 70;

int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 1;

% Variables
var 0..max(max_XY, max_XZ): X;
var 0..max_XY: Y;
var 0..max(max_XZ, min_YZ): Z;

var 0..(cost_X*max(max_XY,max_XZ) + cost_Y*max_XY + cost_Z*max(max_XZ,min_YZ)): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z <= max_XZ;
constraint Y + Z >= min_YZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;