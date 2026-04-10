% Parameters
int: max_total = 1000;

int: min_diff_XY = 200;
int: min_diff_YZ = 100;

int: cost_X = 50;
int: cost_Y = 60;
int: cost_Z = 70;

int: max_X = 500;
int: max_Y = 400;
int: max_Z = 300;

% Variables
var 0..max_X: x;
var 0..max_Y: y;
var 0..max_Z: z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint x >= y + min_diff_XY;
constraint y >= z + min_diff_YZ;

constraint total_cost = cost_X*x + cost_Y*y + cost_Z*z;

% Objective
solve minimize total_cost;