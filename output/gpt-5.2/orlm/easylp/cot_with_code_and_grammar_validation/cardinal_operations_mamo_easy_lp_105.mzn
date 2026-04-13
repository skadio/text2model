% Parameters
int: max_total_hours = 15;
int: min_X_hours = 5;
int: min_Y_hours = 3;
int: fatigue_per_X = 20;
int: fatigue_per_Y = 30;

% Variables
var min_X_hours..max_total_hours: X;
var min_Y_hours..max_total_hours: Y;
var 0..(fatigue_per_X*max_total_hours + fatigue_per_Y*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint total_fatigue = fatigue_per_X * X + fatigue_per_Y * Y;

% Objective
solve minimize total_fatigue;