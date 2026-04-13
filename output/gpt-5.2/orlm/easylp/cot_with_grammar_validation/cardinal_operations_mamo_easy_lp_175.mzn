% Parameters
int: max_XY = 100;
int: min_XZ = 150;
int: max_YZ = 200;

int: cost_X = 3;
int: cost_Y = 4;
int: cost_Z = 5;

% Variables
var 0..200: X;
var 0..200: Y;
var 0..200: Z;

var 0..(cost_X*200 + cost_Y*200 + cost_Z*200): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint Y + Z <= max_YZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;