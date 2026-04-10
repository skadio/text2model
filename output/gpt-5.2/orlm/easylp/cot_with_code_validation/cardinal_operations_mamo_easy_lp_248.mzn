% Parameters
int: max_total_shifts = 24;
int: cost_x = 8;
int: cost_y = 6;
int: cost_z = 10;

int: max_x = 12;
int: max_y = 8;
int: max_z = 6;

int: min_x_minus_y = 2;
int: max_abs_y_minus_z = 4;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..max_z: z;

var 0..(cost_x*max_x + cost_y*max_y + cost_z*max_z): total_cost;

% Constraints
constraint x + y + z <= max_total_shifts;

constraint x >= y + min_x_minus_y;

constraint abs(y - z) <= max_abs_y_minus_z;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;