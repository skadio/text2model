% Parameters
int: total_hours_max = 24;
int: min_x = 6;
int: min_y = 4;
int: min_z = 2;

int: cost_x = 8;
int: cost_y = 5;
int: cost_z = 7;

% Variables
var min_x..total_hours_max: x_hours;
var min_y..total_hours_max: y_hours;
var min_z..total_hours_max: z_hours;

var 0..(cost_x*total_hours_max + cost_y*total_hours_max + cost_z*total_hours_max): total_cost;

% Constraints
constraint x_hours + y_hours + z_hours <= total_hours_max;

constraint total_cost = cost_x * x_hours + cost_y * y_hours + cost_z * z_hours;

% Objective
solve minimize total_cost;