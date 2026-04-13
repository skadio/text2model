% Parameters
int: max_total_hours = 40;
int: min_x_hours = 15;
int: min_y_hours = 10;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..max_total_hours: x;
var 0..max_total_hours: y;
var 0..(cost_x*max_total_hours + cost_y*max_total_hours): total_fatigue;

% Constraints
constraint x >= min_x_hours;
constraint y >= min_y_hours;
constraint x + y <= max_total_hours;
constraint total_fatigue = cost_x * x + cost_y * y;

% Objective
solve minimize total_fatigue;