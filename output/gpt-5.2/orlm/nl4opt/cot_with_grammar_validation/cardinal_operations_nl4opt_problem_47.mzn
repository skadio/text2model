% Parameters
int: min_total_lights = 300;
int: max_electricity = 2000;

int: elec_led = 5;
int: elec_fluor = 8;

int: changes_led = 3;
int: changes_fluor = 4;

int: min_fluor_percent = 30;

% Variables
var 0..(max_electricity div elec_led): led;
var 0..(max_electricity div elec_fluor): fluor;

% Constraints
constraint led + fluor >= min_total_lights;

constraint elec_led * led + elec_fluor * fluor <= max_electricity;

constraint 100 * fluor >= min_fluor_percent * (led + fluor);

% Objective
solve minimize changes_led * led + changes_fluor * fluor;