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
constraint 2 * large <= small;              % at least twice as many small as large
constraint large >= min_large;              % at least 15 large suitcases
constraint small + large <= max_total;      % at most 70 suitcases total

constraint total_snacks = cap_small * small + cap_large * large;

% Objective
solve maximize total_snacks;