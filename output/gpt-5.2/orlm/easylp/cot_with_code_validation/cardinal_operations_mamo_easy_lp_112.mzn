% Parameters
int: max_total_hours = 40;
int: min_x_hours = 15;
int: min_y_hours = 10;
int: fatigue_x_per_hour = 2;
int: fatigue_y_per_hour = 3;

% Variables
var min_x_hours..max_total_hours: x_hours;
var min_y_hours..max_total_hours: y_hours;
var 0..(fatigue_x_per_hour * max_total_hours + fatigue_y_per_hour * max_total_hours): total_fatigue;

% Constraints
constraint x_hours + y_hours <= max_total_hours;
constraint total_fatigue = fatigue_x_per_hour * x_hours + fatigue_y_per_hour * y_hours;

% Objective
solve minimize total_fatigue;