% Parameters
float: time_fertilizer = 0.5;
float: time_seeds = 1.5;

int: max_total_units = 300;
int: min_fertilizer = 50;

% Variables
var 0..max_total_units: fertilizer;
var 0..max_total_units: seeds;

var float: total_time;

% Constraints
constraint fertilizer + seeds <= max_total_units;
constraint fertilizer >= min_fertilizer;
constraint fertilizer <= 2 * seeds;

constraint total_time = time_fertilizer * fertilizer + time_seeds * seeds;

% Objective
solve minimize total_time;