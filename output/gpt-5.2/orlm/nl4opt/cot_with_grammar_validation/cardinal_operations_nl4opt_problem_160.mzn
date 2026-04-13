% Parameters
int: toys_per_medium = 50;
int: toys_per_small  = 35;
int: ops_per_medium  = 3;
int: ops_per_small   = 2;

int: min_toys = 250;
int: max_ops  = 16;

% Upper bounds (safe, derived from operator limit)
int: max_medium = max_ops div ops_per_medium; % floor(16/3)=5
int: max_small  = max_ops div ops_per_small;  % floor(16/2)=8

% Variables
var 0..max_medium: n_medium;
var 0..max_small:  n_small;

% Constraints
constraint
  toys_per_medium * n_medium + toys_per_small * n_small >= min_toys;

constraint
  ops_per_medium * n_medium + ops_per_small * n_small <= max_ops;

% Objective
solve minimize n_medium + n_small;