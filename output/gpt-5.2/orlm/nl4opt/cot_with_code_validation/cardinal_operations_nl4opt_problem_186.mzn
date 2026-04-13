% Parameters
int: cap_small = 20;
int: cap_large = 50;
int: demand = 2000;
int: min_large = 10;
int: small_at_least_factor = 2;

% Variables
var 0..(demand div cap_small + demand div cap_large): n_small;
var min_large..(demand div cap_large): n_large;

% Constraints
constraint cap_small * n_small + cap_large * n_large >= demand;
constraint n_small >= small_at_least_factor * n_large;

% Objective
solve minimize n_small + n_large;