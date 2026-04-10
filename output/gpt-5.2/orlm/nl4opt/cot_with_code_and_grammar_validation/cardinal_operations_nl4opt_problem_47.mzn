% Parameters
int: min_total_lights = 300;
int: max_electricity = 2000;

int: elec_led = 5;
int: elec_fluor = 8;

int: changes_led = 3;
int: changes_fluor = 4;

int: min_fluor_percent = 30;

% Variables
var 0..max_electricity div elec_led: n_led;
var 0..max_electricity div elec_fluor: n_fluor;

% Constraints
constraint
  elec_led * n_led + elec_fluor * n_fluor <= max_electricity;

constraint
  n_led + n_fluor >= min_total_lights;

constraint
  100 * n_fluor >= min_fluor_percent * (n_led + n_fluor);

% Objective
solve minimize changes_led * n_led + changes_fluor * n_fluor;