% Parameters
int: max_total_hours = 24;
int: min_x = 6;
int: min_y = 4;
int: min_z = 2;

int: cost_x = 8;
int: cost_y = 5;
int: cost_z = 7;

% Variables
var min_x..max_total_hours: x;
var min_y..max_total_hours: y;
var min_z..max_total_hours: z;

var 0..(cost_x*max_total_hours + cost_y*max_total_hours + cost_z*max_total_hours): total_cost;

% Constraints
constraint x + y + z <= max_total_hours;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;