% Parameters
int: prod_small = 30;
int: prod_large = 70;
int: workers_small = 2;
int: workers_large = 4;
int: min_production = 500;
int: max_workers = 30;

% Variables
var 0..(max_workers div workers_small): n_small;
var 0..(max_workers div workers_large): n_large;

% Constraints
constraint prod_small * n_small + prod_large * n_large >= min_production;
constraint workers_small * n_small + workers_large * n_large <= max_workers;

% Objective
solve minimize n_small + n_large;