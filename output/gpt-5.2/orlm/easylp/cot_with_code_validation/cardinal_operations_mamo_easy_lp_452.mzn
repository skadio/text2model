% Parameters
int: cost_fertilizer = 5;
int: cost_seeds = 10;

int: total_units = 500;

int: coef1_fertilizer = 2;
int: coef1_seeds = 3;
int: limit1 = 1000;

int: coef2_fertilizer = 4;
int: coef2_seeds = 1;
int: min_diff = 200;

% Variables
var 0..total_units: fertilizer;
var 0..total_units: seeds;
var 0..(cost_fertilizer*total_units + cost_seeds*total_units): total_cost;

% Constraints
constraint fertilizer + seeds = total_units;

constraint coef1_fertilizer * fertilizer + coef1_seeds * seeds <= limit1;

constraint coef2_fertilizer * fertilizer - coef2_seeds * seeds >= min_diff;

constraint total_cost = cost_fertilizer * fertilizer + cost_seeds * seeds;

% Objective
solve minimize total_cost;