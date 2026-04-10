% Parameters (with values embedded)
int: elec_led = 5;              % electricity units per hour per LED
int: elec_fluor = 8;            % electricity units per hour per fluorescence
int: changes_led = 3;           % changes per decade per LED
int: changes_fluor = 4;         % changes per decade per fluorescence

int: min_total_lights = 300;    % at least 300 fixtures
int: max_total_elec = 2000;     % at most 2000 electricity units

int: min_fluor_percent = 30;    % at least 30% fluorescence

% Variables
var 0..min_total_lights: led;
var 0..min_total_lights: fluor;

% Constraints
constraint led + fluor >= min_total_lights;
constraint elec_led * led + elec_fluor * fluor <= max_total_elec;

% At least 30% of installed lights are fluorescence:
% fluor >= 0.30 * (led + fluor)  <=>  10*fluor >= 3*(led+fluor)  <=>  7*fluor >= 3*led
constraint 7 * fluor >= 3 * led;

% Objective
solve minimize changes_led * led + changes_fluor * fluor;