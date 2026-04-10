% Parameters (with values embedded)
int: horses_available = 60;
int: horses_per_medium = 2;
int: horses_per_large = 4;
int: rice_per_medium = 30;
int: rice_per_large = 70;
int: min_medium = 5;
int: min_large = 5;
int: medium_multiple_of_large = 3;

% Variables
var 0..horses_available: medium_carts;
var 0..horses_available: large_carts;

% Constraints
constraint horses_per_medium * medium_carts + horses_per_large * large_carts <= horses_available;
constraint medium_carts = medium_multiple_of_large * large_carts;
constraint medium_carts >= min_medium;
constraint large_carts >= min_large;

% Objective
var int: total_rice = rice_per_medium * medium_carts + rice_per_large * large_carts;
solve maximize total_rice;