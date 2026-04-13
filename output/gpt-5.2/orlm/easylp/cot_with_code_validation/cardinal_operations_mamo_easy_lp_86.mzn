% Parameters
int: max_total_hours = 24;
int: min_x_hours = 4;
int: min_y_hours = 6;
int: cost_x_per_hour = 8;
int: cost_y_per_hour = 10;

% Variables
var min_x_hours..max_total_hours: x_hours;
var min_y_hours..max_total_hours: y_hours;
var 0..(cost_x_per_hour*max_total_hours + cost_y_per_hour*max_total_hours): total_cost;

% Constraints
constraint x_hours + y_hours <= max_total_hours;
constraint total_cost = cost_x_per_hour * x_hours + cost_y_per_hour * y_hours;

% Objective
solve minimize total_cost;