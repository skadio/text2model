% Parameters
int: people_available = 100;

int: people_small = 1;
int: people_large = 3;

int: cap_small = 20;
int: cap_large = 50;

int: ratio_small_to_large = 3;

int: min_small = 5;
int: min_large = 3;

% Variables
var 0..people_available div people_small: small;
var 0..people_available div people_large: large;

var 0..(cap_small * (people_available div people_small) + cap_large * (people_available div people_large)): total_sand;

% Constraints
constraint small = ratio_small_to_large * large;

constraint small >= min_small;
constraint large >= min_large;

constraint people_small * small + people_large * large <= people_available;

constraint total_sand = cap_small * small + cap_large * large;

% Objective
solve maximize total_sand;