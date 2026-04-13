% Parameters
int: max_total_units = 1000;
int: min_2x_plus_y = 200;
int: max_diff_xz = 50;
int: min_y_plus_z = 400;

int: cost_x = 500;
int: cost_y = 300;
int: cost_z = 700;

% Variables
var 0..max_total_units: x;
var 0..max_total_units: y;
var 0..max_total_units: z;

var 0..(max_total_units * max([cost_x, cost_y, cost_z])): total_support;

% Constraints
constraint x + y + z <= max_total_units;
constraint 2*x + y >= min_2x_plus_y;
constraint abs(x - z) <= max_diff_xz;
constraint y + z >= min_y_plus_z;

constraint total_support = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_support;