% Parameters
int: horses_available = 60;

int: horses_per_medium = 2;
int: horses_per_large  = 4;

int: kg_per_medium = 30;
int: kg_per_large  = 70;

int: min_medium = 5;
int: min_large  = 5;

% Variables
var min_medium..(horses_available div horses_per_medium): medium_carts;
var min_large..(horses_available div horses_per_large): large_carts;

var 0..(kg_per_medium*(horses_available div horses_per_medium) + kg_per_large*(horses_available div horses_per_large)): total_kg;

% Constraints
constraint horses_per_medium * medium_carts + horses_per_large * large_carts <= horses_available;

constraint medium_carts = 3 * large_carts;

constraint total_kg = kg_per_medium * medium_carts + kg_per_large * large_carts;

% Objective
solve maximize total_kg;