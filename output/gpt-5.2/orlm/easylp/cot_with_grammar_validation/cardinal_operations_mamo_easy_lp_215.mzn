% Parameters
int: cost_X = 5;
int: cost_Y = 3;
int: cost_Z = 4;

int: max_X = 500;
int: max_Y = 300;
int: max_Z = 200;

int: limit_XY = 1000;
int: limit_YZ = 800;

int: min_diff_XZ = 200;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint X + Y <= limit_XY;
constraint Y + Z <= limit_YZ;
constraint abs(X - Z) >= min_diff_XZ;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;