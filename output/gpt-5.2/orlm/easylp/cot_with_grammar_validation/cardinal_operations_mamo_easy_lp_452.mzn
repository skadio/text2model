% Parameters
int: cost_fertilizer = 5;
int: cost_seeds = 10;

int: total_units = 500;

int: a_fertilizer = 2;
int: b_seeds = 3;
int: cap_mix = 1000;

int: c_fertilizer = 4;
int: d_seeds = 1;
int: min_diff = 200;

% Variables
var 0..total_units: fertilizer;
var 0..total_units: seeds;

var 0..(cost_fertilizer * total_units + cost_seeds * total_units): total_cost;

% Constraints
constraint fertilizer + seeds = total_units;

constraint a_fertilizer * fertilizer + b_seeds * seeds <= cap_mix;

constraint c_fertilizer * fertilizer - d_seeds * seeds >= min_diff;

constraint total_cost = cost_fertilizer * fertilizer + cost_seeds * seeds;

% Objective
solve minimize total_cost;