% Parameters (with values embedded)
int: time_anxiety = 3;
int: time_antidepressant = 5;
int: min_total_units = 100;
int: min_anxiety_units = 30;

% Variables
var 0..1000: x; % units of anxiety medication
var 0..1000: y; % units of anti-depressants

% Constraints
constraint x + y >= min_total_units;
constraint x >= min_anxiety_units;
constraint x <= 2 * y;

% Objective
solve minimize time_anxiety * x + time_antidepressant * y;