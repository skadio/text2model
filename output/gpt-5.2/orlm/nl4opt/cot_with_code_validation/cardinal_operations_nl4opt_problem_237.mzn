% Parameters
int: cap_small = 200;
int: cap_large = 500;

int: max_small = 100;
int: max_large = 50;

int: max_total = 60;
int: min_large = 10;

int: small_per_large = 3;

% Variables
var 0..max_small: small;
var 0..max_large: large;

var 0..(cap_small*max_small + cap_large*max_large): total_grapes;

% Constraints
constraint small <= max_small;
constraint large <= max_large;

constraint small + large <= max_total;
constraint large >= min_large;

constraint small >= small_per_large * large;

constraint total_grapes = cap_small * small + cap_large * large;

% Objective
solve maximize total_grapes;