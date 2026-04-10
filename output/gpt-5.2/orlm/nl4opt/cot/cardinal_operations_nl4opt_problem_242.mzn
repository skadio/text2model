% Parameters (with values embedded)
int: prod_small = 30;
int: workers_small = 2;
int: prod_large = 70;
int: workers_large = 4;

int: min_hotdogs = 500;
int: max_workers = 30;

% Variables
var 0..(max_workers div workers_small): x_small;  % number of small shops
var 0..(max_workers div workers_large): x_large;  % number of large shops

var 0..(max_workers div 2): total_shops;

% Constraints
constraint total_shops = x_small + x_large;

constraint prod_small * x_small + prod_large * x_large >= min_hotdogs;
constraint workers_small * x_small + workers_large * x_large <= max_workers;

% Objective
solve minimize total_shops;