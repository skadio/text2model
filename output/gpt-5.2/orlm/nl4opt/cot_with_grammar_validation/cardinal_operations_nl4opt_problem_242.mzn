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
var 0..(max_workers div workers_small + max_workers div workers_large): total_shops;

% Constraints
constraint prod_small * n_small + prod_large * n_large >= min_production;
constraint workers_small * n_small + workers_large * n_large <= max_workers;
constraint total_shops = n_small + n_large;

% Objective
solve minimize total_shops;