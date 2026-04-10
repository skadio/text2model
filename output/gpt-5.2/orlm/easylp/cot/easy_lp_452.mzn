% Parameters (with values embedded)
int: cost_fertilizer = 5;
int: cost_seeds = 10;
int: total_units = 500;

int: max_weighted = 1000;   % 2*fertilizer + 3*seeds <= 1000
int: min_diff = 200;        % 4*fertilizer - seeds >= 200

% Variables
var 0..total_units: fertilizer;
var 0..total_units: seeds;

var 0..(cost_fertilizer*total_units + cost_seeds*total_units): total_cost;

% Constraints
constraint fertilizer + seeds = total_units;

constraint 2*fertilizer + 3*seeds <= max_weighted;

constraint 4*fertilizer - seeds >= min_diff;

constraint total_cost = cost_fertilizer*fertilizer + cost_seeds*seeds;

% Objective
solve minimize total_cost;