% Parameters
int: time_anxiety = 3;
int: time_antidepressant = 5;
int: min_total_units = 100;
int: min_anxiety_units = 30;

% Variables
var 0..min_total_units: anxiety;
var 0..min_total_units: antidepressant;

% Constraints
constraint anxiety + antidepressant >= min_total_units;
constraint anxiety >= min_anxiety_units;
constraint anxiety <= 2 * antidepressant;

% Objective
solve minimize time_anxiety * anxiety + time_antidepressant * antidepressant;