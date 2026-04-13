% Parameters
int: max_total_hours = 24;
int: min_diff_XY = 2;
int: max_YZ_hours = 16;

int: cost_X = 8;
int: cost_Y = 6;
int: cost_Z = 5;

int: X_lb = 0; int: X_ub = 10;
int: Y_lb = 0; int: Y_ub = 8;
int: Z_lb = 0; int: Z_ub = 6;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var 0..(cost_X*X_ub + cost_Y*Y_ub + cost_Z*Z_ub): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint X >= Y + min_diff_XY;

constraint Y + Z <= max_YZ_hours;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;