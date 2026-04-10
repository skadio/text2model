% Parameters (with values embedded)
int: max_total_hours = 50;
int: min_effectiveness = 20;
int: max_diff = 10;
int: fatigue_x = 5;
int: fatigue_y = 3;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - 3*Y) <= max_diff;

constraint total_fatigue = fatigue_x*X + fatigue_y*Y;

% Objective
solve minimize total_fatigue;