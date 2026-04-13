% Parameters
int: cap_small = 50;
int: cap_large = 80;

int: max_small = 70;
int: max_large = 50;

int: min_large = 15;
int: max_total = 70;

% Variables
var 0..max_small: small;
var 0..max_large: large;

var 0..(cap_small*max_small + cap_large*max_large): total_snacks;

% Constraints
constraint small >= 2 * large;
constraint large >= min_large;

constraint small + large <= max_total;

constraint total_snacks = cap_small * small + cap_large * large;

% Objective
solve maximize total_snacks;