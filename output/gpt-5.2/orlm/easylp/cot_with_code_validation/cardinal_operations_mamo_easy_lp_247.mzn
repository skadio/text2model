% Parameters
int: max_total_hours = 24;
int: min_x = 6;
int: min_y = 4;
int: min_z = 2;

int: cost_x = 8;
int: cost_y = 5;
int: cost_z = 7;

% Variables
var min_x..max_total_hours: x_hours;
var min_y..max_total_hours: y_hours;
var min_z..max_total_hours: z_hours;

var 0..(cost_x*max_total_hours + cost_y*max_total_hours + cost_z*max_total_hours): total_cost;

% Constraints
constraint x_hours + y_hours + z_hours <= max_total_hours;

constraint total_cost = cost_x*x_hours + cost_y*y_hours + cost_z*z_hours;

% Objective
solve minimize total_cost;