% Parameters
int: time_cleanse_per_unit = 4;
int: time_odor_per_unit = 6;

int: min_cleanse = 100;
int: min_total = 300;

% Variables
var 0..100000: cleanse_units;
var 0..100000: odor_units;
var 0..1000000: total_time;

% Constraints
constraint cleanse_units >= min_cleanse;
constraint cleanse_units + odor_units >= min_total;
constraint cleanse_units <= 2 * odor_units;

constraint total_time = time_cleanse_per_unit * cleanse_units + time_odor_per_unit * odor_units;

% Objective
solve minimize total_time;