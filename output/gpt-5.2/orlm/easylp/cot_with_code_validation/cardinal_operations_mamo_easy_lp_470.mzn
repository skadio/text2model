% Parameters
int: max_total_hours = 10;
int: min_diff = 1;
int: eq_a = 2;
int: eq_b = 1;
int: eq_rhs = 15;
int: fatigue_x = 2;
int: fatigue_y = 3;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint X >= Y + min_diff;
constraint eq_a * X + eq_b * Y = eq_rhs;

constraint total_fatigue = fatigue_x * X + fatigue_y * Y;

% Objective
solve minimize total_fatigue;