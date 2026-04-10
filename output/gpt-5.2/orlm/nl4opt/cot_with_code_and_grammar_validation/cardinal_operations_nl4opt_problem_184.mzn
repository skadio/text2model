% Parameters
int: horses_available = 60;

int: horses_per_medium = 2;
int: horses_per_large = 4;

int: kg_per_medium = 30;
int: kg_per_large = 70;

int: min_medium = 5;
int: min_large = 5;

int: ratio_medium_to_large = 3;

% Variables
var 0..(horses_available div horses_per_medium): medium;
var 0..(horses_available div horses_per_large): large;
var 0..(horses_available * max(kg_per_medium, kg_per_large)): total_kg;

% Constraints
constraint medium >= min_medium;
constraint large >= min_large;

constraint medium = ratio_medium_to_large * large;

constraint horses_per_medium * medium + horses_per_large * large <= horses_available;

constraint total_kg = kg_per_medium * medium + kg_per_large * large;

% Objective
solve maximize total_kg;