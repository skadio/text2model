% Parameters
int: max_total_hours = 10;
int: min_effectiveness = 30;
int: max_diff = 2;

int: eff_x = 3;
int: eff_y = 4;

int: fatigue_x = 40;
int: fatigue_y = 60;

int: max_x = 6;
int: max_y = 8;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..(fatigue_x*max_x + fatigue_y*max_y): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint eff_x * X + eff_y * Y >= min_effectiveness;
constraint abs(X - Y) <= max_diff;
constraint total_fatigue = fatigue_x * X + fatigue_y * Y;

% Objective
solve minimize total_fatigue;