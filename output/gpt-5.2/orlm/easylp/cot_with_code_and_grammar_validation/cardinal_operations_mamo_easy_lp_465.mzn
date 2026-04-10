% Parameters
int: min_hours_x = 10;
int: min_hours_y = 5;
int: max_total_hours = 40;
int: cost_per_hour_x = 50;
int: cost_per_hour_y = 80;

% Variables
var min_hours_x..max_total_hours: hours_x;
var min_hours_y..max_total_hours: hours_y;
var 0..(cost_per_hour_x*max_total_hours + cost_per_hour_y*max_total_hours): total_cost;

% Constraints
constraint hours_x + hours_y <= max_total_hours;
constraint total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;

% Objective
solve minimize total_cost;