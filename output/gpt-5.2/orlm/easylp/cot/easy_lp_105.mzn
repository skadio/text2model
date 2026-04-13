% Parameters (with values embedded)
int: max_total_hours = 15;
int: min_X = 5;
int: min_Y = 3;
int: fatigue_per_X = 20;
int: fatigue_per_Y = 30;

% Variables
var int: X; % strength conditioning hours
var int: Y; % skill development hours
var int: total_fatigue;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;
constraint X + Y <= max_total_hours;

constraint total_fatigue = fatigue_per_X * X + fatigue_per_Y * Y;

% Objective
solve minimize total_fatigue;