% Parameters
int: max_XY = 10;
int: max_ZW = 20;
int: min_XZ = 5;
int: min_YW = 7;

int: cost_X = 1000;
int: cost_Y = 2000;
int: cost_Z = 500;
int: cost_W = 1500;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_ZW: Z;
var 0..max_ZW: W;

var 0..(max_XY*cost_X + max_XY*cost_Y + max_ZW*cost_Z + max_ZW*cost_W): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z + cost_W*W;

% Objective
solve minimize total_cost;