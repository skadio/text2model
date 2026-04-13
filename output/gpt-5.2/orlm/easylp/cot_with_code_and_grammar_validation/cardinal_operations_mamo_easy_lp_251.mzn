% Parameters
int: max_total_hours = 24;
int: min_diff_XY = 2;
int: max_YZ_hours = 16;

int: cost_X = 8;
int: cost_Y = 6;
int: cost_Z = 5;

int: X_min = 0;
int: X_max = 10;
int: Y_min = 0;
int: Y_max = 8;
int: Z_min = 0;
int: Z_max = 6;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

var 0..(cost_X*X_max + cost_Y*Y_max + cost_Z*Z_max): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hours;
constraint X >= Y + min_diff_XY;
constraint Y + Z <= max_YZ_hours;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;