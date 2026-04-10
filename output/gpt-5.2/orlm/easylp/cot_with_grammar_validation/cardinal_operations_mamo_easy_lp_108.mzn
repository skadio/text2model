% Parameters
int: total_time_max = 20;
int: x_min_more_than_y = 5;
int: fatigue_x = 2;
int: fatigue_y = 3;
int: x_max = 15;
int: y_max = 10;

% Variables
var 0..x_max: x_hours;
var 0..y_max: y_hours;
var 0..(fatigue_x * x_max + fatigue_y * y_max): total_fatigue;

% Constraints
constraint x_hours + y_hours <= total_time_max;
constraint x_hours >= y_hours + x_min_more_than_y;
constraint total_fatigue = fatigue_x * x_hours + fatigue_y * y_hours;

% Objective
solve minimize total_fatigue;