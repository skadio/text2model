% Parameters
int: max_XY = 100;
int: max_ZW = 200;
int: min_XZ = 50;
int: min_YW = 70;

int: cost_X = 10;
int: cost_Y = 15;
int: cost_Z = 25;
int: cost_W = 30;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_ZW: Z;
var 0..max_ZW: W;

var 0..(cost_X*max_XY + cost_Y*max_XY + cost_Z*max_ZW + cost_W*max_ZW): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z + cost_W*W;

% Objective
solve minimize total_cost;