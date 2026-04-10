% Parameters
int: fatigue_x = 2;
int: fatigue_y = 3;

int: max_total_hours = 100;
int: min_x_minus_y = 10;
int: min_2x_plus_y = 60;

% Variables
var 0..max_total_hours: x;
var 0..max_total_hours: y;
var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours): total_fatigue;

% Constraints
constraint x + y <= max_total_hours;
constraint x - y >= min_x_minus_y;
constraint 2*x + y >= min_2x_plus_y;

constraint total_fatigue = fatigue_x * x + fatigue_y * y;

% Objective
solve minimize total_fatigue;