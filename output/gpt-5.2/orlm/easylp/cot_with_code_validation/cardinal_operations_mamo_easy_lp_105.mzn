% Parameters
int: max_total_hours = 15;
int: min_strength_hours = 5;
int: min_skill_hours = 3;
int: fatigue_strength_per_hour = 20;
int: fatigue_skill_per_hour = 30;

% Variables
var min_strength_hours..max_total_hours: X;  % strength conditioning hours
var min_skill_hours..max_total_hours: Y;     % skill development hours
var 0..(fatigue_strength_per_hour*max_total_hours + fatigue_skill_per_hour*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint total_fatigue = fatigue_strength_per_hour * X + fatigue_skill_per_hour * Y;

% Objective
solve minimize total_fatigue;