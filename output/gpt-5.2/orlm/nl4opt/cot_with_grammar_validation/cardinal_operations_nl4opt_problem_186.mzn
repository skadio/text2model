% Parameters
int: cap_small = 20;
int: cap_large = 50;
int: ore_required = 2000;
int: min_large = 10;
int: small_per_large = 2;

% Variables
var 0..ore_required div cap_small + ore_required div cap_large: n_small;
var min_large..ore_required div cap_large: n_large;
var 0..(ore_required div cap_small + ore_required div cap_large): total_wagons;

% Constraints
constraint cap_small * n_small + cap_large * n_large >= ore_required;

constraint n_small >= small_per_large * n_large;

constraint total_wagons = n_small + n_large;

% Objective
solve minimize total_wagons;