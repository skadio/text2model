% Parameters
int: max_total_hours = 40;
int: min_x_hours = 15;
int: min_y_hours = 10;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var min_x_hours..max_total_hours: X;
var min_y_hours..max_total_hours: Y;
var 0..(cost_x*max_total_hours + cost_y*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint total_fatigue = cost_x * X + cost_y * Y;

% Objective
solve minimize total_fatigue;