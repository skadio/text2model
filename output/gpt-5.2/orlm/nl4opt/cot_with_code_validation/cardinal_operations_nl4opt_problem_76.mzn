% Parameters
int: cap_small = 40;
int: cap_large = 100;

int: max_small = 30;
int: max_large = 10;

int: max_total = 25;
int: min_large = 5;

int: small_at_least_factor = 2;

% Variables
var 0..max_small: n_small;
var 0..max_large: n_large;
var 0..(cap_small*max_small + cap_large*max_large): total_liters;

% Constraints
constraint n_small + n_large <= max_total;
constraint n_large >= min_large;
constraint n_small >= small_at_least_factor * n_large;

constraint total_liters = cap_small * n_small + cap_large * n_large;

% Objective
solve maximize total_liters;