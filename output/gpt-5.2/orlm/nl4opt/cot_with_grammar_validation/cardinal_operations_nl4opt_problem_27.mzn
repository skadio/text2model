% Parameters
int: cool_low = 12;
int: elec_low = 150;

int: cool_high = 17;
int: elec_high = 250;

int: min_units = 250;
int: elec_available = 3400;

float: max_low_fraction = 0.30;
int: min_high = 7;

% Variables
var 0..min_units: n_low;
var min_high..min_units: n_high;

% Constraints
constraint cool_low * n_low + cool_high * n_high >= min_units;
constraint elec_low * n_low + elec_high * n_high <= elec_available;

% low-powered models are at most 30% of total: n_low <= 0.30*(n_low+n_high)
% Multiply by 10 to avoid floats: 10*n_low <= 3*(n_low+n_high)  <=> 7*n_low <= 3*n_high
constraint 7 * n_low <= 3 * n_high;

% Objective
solve minimize n_low + n_high;