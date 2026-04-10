% Parameters
float: time_per_unit_coconut = 0.7;      % minutes per unit of coconut oil
float: time_per_unit_lavender = 0.9;     % minutes per unit of lavender

int: min_coconut = 300;                  % minimum required units of coconut oil
int: max_each_ingredient = 550;          % maximum allowed units of each ingredient
int: coconut_to_lavender_ratio = 3;      % coconut <= 3 * lavender

% Variables
var 0..max_each_ingredient: coconut_units;    % units of coconut oil to add
var 0..max_each_ingredient: lavender_units;   % units of lavender to add
var float: total_time;                        % total time for mixture to be effective

% Constraints
% --- Domain constraints (respect ingredient bounds) ---
constraint coconut_units >= min_coconut;                 % at least 300 units of coconut oil

% --- Composition constraint (avoid overly oily mixture) ---
constraint coconut_units <= coconut_to_lavender_ratio * lavender_units;  % coconut <= 3 * lavender

% --- Total time definition (sum of per-unit effectiveness times) ---
constraint total_time = time_per_unit_coconut * int2float(coconut_units)
                      + time_per_unit_lavender * int2float(lavender_units);

% Objective
solve minimize total_time;