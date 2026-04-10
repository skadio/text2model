% Parameters
int: total_hours_limit = 10;
int: eff_x = 3;
int: eff_y = 4;
int: min_effectiveness = 30;
int: max_diff = 2;
int: fatigue_x = 40;
int: fatigue_y = 60;
int: max_x = 6;
int: max_y = 8;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(fatigue_x * max_x + fatigue_y * max_y): total_fatigue;

% Constraints
constraint x + y <= total_hours_limit;
constraint eff_x * x + eff_y * y >= min_effectiveness;
constraint abs(x - y) <= max_diff;

constraint total_fatigue = fatigue_x * x + fatigue_y * y;

% Objective
solve minimize total_fatigue;