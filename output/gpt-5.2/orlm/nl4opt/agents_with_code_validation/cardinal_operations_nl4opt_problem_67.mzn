% Parameters
float: time_per_fertilizer_unit = 0.5;   % minutes per unit of fertilizer
float: time_per_seed_unit       = 1.5;   % minutes per unit of seeds

int: max_total_units = 300;              % maximum combined units of fertilizer and seeds
int: min_fertilizer_units = 50;          % minimum fertilizer units required
int: fertilizer_to_seed_ratio_max = 2;   % fertilizer can be at most this multiple of seeds

% Variables
var 0..max_total_units: fertilizer_units;  % units of fertilizer to apply
var 0..max_total_units: seed_units;        % units of seeds to apply

var 0.0..(time_per_seed_unit * max_total_units): total_time; % total time in minutes

% Constraints

% Link total_time to the chosen quantities (type-consistent linear expression)
constraint
  total_time = time_per_fertilizer_unit * int2float(fertilizer_units)
             + time_per_seed_unit       * int2float(seed_units);

% Total application limit (fertilizer + seeds cannot exceed max_total_units)
constraint
  fertilizer_units + seed_units <= max_total_units;

% Minimum fertilizer requirement
constraint
  fertilizer_units >= min_fertilizer_units;

% Patchy lawn ratio constraint: fertilizer at most fertilizer_to_seed_ratio_max * seeds
constraint
  fertilizer_units <= fertilizer_to_seed_ratio_max * seed_units;

% Objective
solve minimize total_time;