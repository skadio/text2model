% Parameters
int: people_available = 30;
int: people_per_small = 2;
int: people_per_large = 4;
int: cap_small = 30;
int: cap_large = 50;

int: min_small = 10;
int: min_large = 3;

% Variables
var 0..people_available div people_per_small: small;
var 0..people_available div people_per_large: large;
var 0..(cap_small*(people_available div people_per_small) + cap_large*(people_available div people_per_large)): total_snow;

% Constraints
constraint people_per_small * small + people_per_large * large <= people_available;

constraint small >= min_small;
constraint large >= min_large;

constraint small = 2 * large;

constraint total_snow = cap_small * small + cap_large * large;

% Objective
solve maximize total_snow;