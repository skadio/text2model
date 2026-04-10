% Parameters
% Time (minutes) per unit
float: time_per_fertilizer = 0.5;
float: time_per_seeds      = 1.5;

% Capacity/requirement limits
int: max_total_units = 300;      % fertilizer + seeds <= 300
int: min_fertilizer  = 50;       % fertilizer >= 50
int: fert_seed_ratio = 2;        % fertilizer <= 2 * seeds

% Variables
var 0..max_total_units: fertilizer_units; % units of fertilizer to add
var 0..max_total_units: seeds_units;      % units of seeds to add

% Constraints
% Total units capacity: fertilizer + seeds cannot exceed the maximum allowed
constraint fertilizer_units + seeds_units <= max_total_units;

% Minimum fertilizer requirement: ensure at least the required amount of fertilizer is used
constraint fertilizer_units >= min_fertilizer;

% Patchiness ratio constraint: fertilizer can be at most a multiple of seeds
constraint fertilizer_units <= fert_seed_ratio * seeds_units;

% Objective
solve minimize time_per_fertilizer * fertilizer_units
             + time_per_seeds * seeds_units;