% Parameters
int: workers_available = 100;
int: workers_small = 2;
int: workers_large = 5;

int: cap_small = 25;
int: cap_large = 60;

int: min_small = 10;
int: min_large = 4;

int: ratio_small_to_large = 3;

% Variables
var 0..(workers_available div workers_small): n_small;
var 0..(workers_available div workers_large): n_large;

var 0..(cap_small * (workers_available div workers_small) + cap_large * (workers_available div workers_large)): total_capacity;

% Constraints
constraint n_small >= min_small;
constraint n_large >= min_large;

constraint n_small = ratio_small_to_large * n_large;

constraint workers_small * n_small + workers_large * n_large <= workers_available;

constraint total_capacity = cap_small * n_small + cap_large * n_large;

% Objective
solve maximize total_capacity;