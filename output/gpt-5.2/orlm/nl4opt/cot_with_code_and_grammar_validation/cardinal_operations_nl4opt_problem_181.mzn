% Parameters
int: time_anxiety = 3;
int: time_antidepressant = 5;

int: min_total_units = 100;
int: min_anxiety_units = 30;

% Variables
var 0..min_total_units: anxiety;
var 0..min_total_units: antidepressant;
var 0..(time_anxiety * min_total_units + time_antidepressant * min_total_units): total_time;

% Constraints
constraint anxiety + antidepressant >= min_total_units;
constraint anxiety >= min_anxiety_units;
constraint anxiety <= 2 * antidepressant;

constraint total_time = time_anxiety * anxiety + time_antidepressant * antidepressant;

% Objective
solve minimize total_time;