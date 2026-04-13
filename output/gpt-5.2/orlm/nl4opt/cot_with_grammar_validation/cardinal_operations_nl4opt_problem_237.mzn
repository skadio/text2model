% Parameters
int: cap_small = 200;
int: cap_large = 500;

int: max_small = 100;
int: max_large = 50;

int: max_total_crates = 60;
int: min_large = 10;

int: small_per_large = 3;

% Variables
var 0..max_small: small;
var min_large..max_large: large;
var 0..(cap_small * max_small + cap_large * max_large): total_grapes;

% Constraints
constraint small >= small_per_large * large;
constraint small + large <= max_total_crates;

constraint total_grapes = cap_small * small + cap_large * large;

% Objective
solve maximize total_grapes;