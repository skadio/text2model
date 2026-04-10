% Parameters
int: toys_medium = 50;
int: toys_small  = 35;
int: ops_medium  = 3;
int: ops_small   = 2;

int: min_toys = 250;
int: max_ops  = 16;

% Variables
var 0..(max_ops div ops_medium): x_medium;
var 0..(max_ops div ops_small):  x_small;

% Constraints
constraint ops_medium * x_medium + ops_small * x_small <= max_ops;
constraint toys_medium * x_medium + toys_small * x_small >= min_toys;

% Objective
solve minimize x_medium + x_small;