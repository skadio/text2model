% Parameters
% Types of lights
int: nLights = 2;
set of int: LIGHTS = 1..nLights;

int: LED = 1;
int: FLUO = 2;

% Electricity use per hour (units) for each light type
array[LIGHTS] of int: electricity_per_light = [5, 8];

% Number of changes per decade for each light type
array[LIGHTS] of int: changes_per_decade = [3, 4];

% Requirements / limits
int: min_total_lights = 300;          % at least 300 fixtures installed
int: max_total_electricity = 2000;    % at most 2000 electricity units
float: min_fluo_fraction = 0.30;      % at least 30% fluorescence (used conceptually; constraint below avoids floats)


% Variables
% Number of installed lights of each type
% Upper bound is safely set to min_total_lights (any extras would only worsen electricity and changes)
array[LIGHTS] of var 0..min_total_lights: num_installed;

% Total number of light changes (objective variable)
var 0..(max(changes_per_decade) * min_total_lights): total_changes;


% Constraints

% --- Total number of installed lights must meet minimum requirement ---
constraint
  sum(l in LIGHTS)(num_installed[l]) >= min_total_lights;

% --- Total electricity consumption must not exceed the limit ---
constraint
  sum(l in LIGHTS)(electricity_per_light[l] * num_installed[l]) <= max_total_electricity;

% --- At least 30% of installed lights must be fluorescence ---
% Avoid float/integer coercion by multiplying through:
% num_installed[FLUO] >= 0.30 * total  <=>  10*FLUO >= 3*total
constraint
  10 * num_installed[FLUO] >= 3 * sum(l in LIGHTS)(num_installed[l]);

% --- Define total_changes as total number of changes per decade across all installed lights ---
constraint
  total_changes = sum(l in LIGHTS)(changes_per_decade[l] * num_installed[l]);


% Objective
solve minimize total_changes;