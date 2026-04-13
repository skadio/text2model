% Parameters
int: min_total_lights = 300;                 % Minimum total fixtures required
int: max_electricity = 2000;                 % Maximum total electricity usage (units per hour)
int: led_elec_per_light = 5;                 % Electricity per LED fixture (units per hour)
int: fluo_elec_per_light = 8;                % Electricity per fluorescence lamp (units per hour)
int: led_changes_per_decade = 3;             % Number of LED changes per decade
int: fluo_changes_per_decade = 4;            % Number of fluorescence changes per decade
int: min_fluo_percent = 30;                  % Minimum percentage of fluorescence lamps

% Variables
var 0..(max_electricity div led_elec_per_light): n_led;    % Number of LED fixtures installed
var 0..(max_electricity div fluo_elec_per_light): n_fluo;  % Number of fluorescence lamps installed
var 0..(led_changes_per_decade*(max_electricity div led_elec_per_light)
      + fluo_changes_per_decade*(max_electricity div fluo_elec_per_light)): total_changes; % Total changes per decade

% Constraints
% --- Total fixtures requirement ---
% Ensure the customer gets at least the required number of light fixtures
constraint
  n_led + n_fluo >= min_total_lights;

% --- Electricity usage limit ---
% Total electricity used by all installed lights must not exceed the maximum allowed
constraint
  led_elec_per_light * n_led + fluo_elec_per_light * n_fluo <= max_electricity;

% --- Minimum percentage of fluorescence lamps ---
% At least min_fluo_percent percent of the installed lights must be fluorescent.
% Use integer arithmetic to avoid floating-point coercion:
% 100 * n_fluo >= min_fluo_percent * (n_led + n_fluo)
constraint
  100 * n_fluo >= min_fluo_percent * (n_led + n_fluo);

% --- Define total number of changes per decade ---
% Total changes is the sum of changes from each type installed
constraint
  total_changes = led_changes_per_decade * n_led + fluo_changes_per_decade * n_fluo;

% Objective
solve minimize total_changes;