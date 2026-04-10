% Parameters
int: max_total_hours = 20;
int: min_diff_X_over_Y = 5;

int: fatigue_per_hour_X = 2;
int: fatigue_per_hour_Y = 3;

int: max_hours_X = 15;
int: max_hours_Y = 10;

% Variables
var 0..max_hours_X: hours_X;
var 0..max_hours_Y: hours_Y;

var int: total_fatigue;

% Constraints
constraint hours_X + hours_Y <= max_total_hours;
constraint hours_X >= hours_Y + min_diff_X_over_Y;

constraint total_fatigue = fatigue_per_hour_X * hours_X + fatigue_per_hour_Y * hours_Y;

% Objective
solve minimize total_fatigue;