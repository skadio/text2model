% Parameters
int: cap_small = 200;
int: cap_large = 500;

int: max_small = 100;
int: max_large = 50;

int: max_total_crates = 60;
int: min_large = 10;

int: small_to_large_ratio = 3;

% Variables
var 0..max_small: n_small;
var 0..max_large: n_large;

% Constraints
constraint n_small <= max_small;
constraint n_large <= max_large;

constraint n_small + n_large <= max_total_crates;

constraint n_large >= min_large;

% at least 3 times as many small as large
constraint n_small >= small_to_large_ratio * n_large;

% Objective
solve maximize cap_small * n_small + cap_large * n_large;