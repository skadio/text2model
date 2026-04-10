% Parameters
int: max_total_shifts = 24;
int: cost_X = 8;
int: cost_Y = 6;
int: cost_Z = 10;

int: max_X = 12;
int: max_Y = 8;
int: max_Z = 6;

int: min_diff_XY = 2;
int: max_abs_diff_YZ = 4;

% Variables
var 0..max_X: x;
var 0..max_Y: y;
var 0..max_Z: z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint x + y + z <= max_total_shifts;

constraint x >= y + min_diff_XY;

constraint abs(y - z) <= max_abs_diff_YZ;

constraint total_cost = cost_X*x + cost_Y*y + cost_Z*z;

% Objective
solve minimize total_cost;