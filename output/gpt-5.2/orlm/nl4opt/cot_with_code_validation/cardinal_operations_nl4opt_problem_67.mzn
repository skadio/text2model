% Parameters
float: time_fertilizer = 0.5;
float: time_seeds = 1.5;
int: max_total_units = 300;
int: min_fertilizer = 50;

% Variables
var 0..max_total_units: fertilizer_units;
var 0..max_total_units: seed_units;
var float: total_time;

% Constraints
constraint fertilizer_units + seed_units <= max_total_units;
constraint fertilizer_units >= min_fertilizer;
constraint fertilizer_units <= 2 * seed_units;

constraint total_time = time_fertilizer * int2float(fertilizer_units)
                      + time_seeds * int2float(seed_units);

% Objective
solve minimize total_time;