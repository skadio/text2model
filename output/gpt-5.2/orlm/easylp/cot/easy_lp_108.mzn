% Parameters (with values embedded)
int: total_time_limit = 20;
int: min_diff_X_over_Y = 5;
int: max_X = 15;
int: max_Y = 10;
int: fatigue_per_hour_X = 2;
int: fatigue_per_hour_Y = 3;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..(fatigue_per_hour_X*max_X + fatigue_per_hour_Y*max_Y): total_fatigue;

% Constraints
constraint X + Y <= total_time_limit;
constraint X >= Y + min_diff_X_over_Y;
constraint total_fatigue = fatigue_per_hour_X * X + fatigue_per_hour_Y * Y;

% Objective
solve minimize total_fatigue;