% Parameters
int: cost_X = 4000;
int: cost_Y = 3000;
int: cost_Z = 6000;
int: cost_W = 5000;

int: max_X = 30;
int: max_Y = 25;
int: max_Z = 20;
int: max_W = 15;

int: max_XY = 50;
int: max_ZW = 40;

int: min_XZ = 30;
int: min_YW = 20;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;
var 0..max_W: W;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z + cost_W*max_W): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z + cost_W*W;

% Objective
solve minimize total_cost;