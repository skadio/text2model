% Parameters
int: max_total_hours = 15;
int: min_X = 5;
int: min_Y = 3;
int: fatigue_X = 20;
int: fatigue_Y = 30;

% Variables
var min_X..max_total_hours: X;
var min_Y..max_total_hours: Y;
var 0..(max_total_hours * max(fatigue_X, fatigue_Y)): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint total_fatigue = fatigue_X * X + fatigue_Y * Y;

% Objective
solve minimize total_fatigue;