% Parameters
int: max_total_hours = 50;
int: min_effectiveness = 20;
int: diff_limit = 10;

int: eff_x = 2;
int: eff_y = 1;

int: fatigue_x = 5;
int: fatigue_y = 3;

% Variables
var 0..max_total_hours: x; % hours of workout X (integer)
var 0..max_total_hours: y; % hours of workout Y (integer)
var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours): total_fatigue;

% Constraints
constraint x + y <= max_total_hours;

constraint eff_x * x + eff_y * y >= min_effectiveness;

constraint abs(x - 3*y) <= diff_limit;

constraint total_fatigue = fatigue_x * x + fatigue_y * y;

% Objective
solve minimize total_fatigue;