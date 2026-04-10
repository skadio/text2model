% Parameters
int: prod_small = 30;
int: workers_small = 2;
int: prod_large = 70;
int: workers_large = 4;

int: demand = 500;
int: workers_avail = 30;

% Variables
var 0..(workers_avail div workers_small): n_small;
var 0..(workers_avail div workers_large): n_large;

% Constraints
constraint
  prod_small * n_small + prod_large * n_large >= demand;

constraint
  workers_small * n_small + workers_large * n_large <= workers_avail;

% Objective
solve minimize n_small + n_large;