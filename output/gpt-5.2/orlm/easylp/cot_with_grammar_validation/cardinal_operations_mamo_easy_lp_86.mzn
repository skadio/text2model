% Parameters
int: max_total_hours = 24;
int: min_hours_x = 4;
int: min_hours_y = 6;
int: cost_x = 8;
int: cost_y = 10;

% Variables
var min_hours_x..max_total_hours: hours_x;
var min_hours_y..max_total_hours: hours_y;
var 0..(cost_x*max_total_hours + cost_y*max_total_hours): total_cost;

% Constraints
constraint hours_x + hours_y <= max_total_hours;
constraint total_cost = cost_x * hours_x + cost_y * hours_y;

% Objective
solve minimize total_cost;