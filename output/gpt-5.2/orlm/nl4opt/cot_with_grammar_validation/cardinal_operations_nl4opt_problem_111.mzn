% Parameters
int: people_available = 30;
int: people_per_small = 2;
int: people_per_large = 4;

int: cap_small = 30;
int: cap_large = 50;

int: min_small = 10;
int: min_large = 3;

int: small_multiple_of_large = 2;

% Variables
var 0..(people_available div people_per_small): small_trucks;
var 0..(people_available div people_per_large): large_trucks;

var 0..(cap_small*(people_available div people_per_small) + cap_large*(people_available div people_per_large)): total_snow;

% Constraints
constraint people_per_small * small_trucks + people_per_large * large_trucks <= people_available;

constraint small_trucks >= min_small;
constraint large_trucks >= min_large;

constraint small_trucks = small_multiple_of_large * large_trucks;

constraint total_snow = cap_small * small_trucks + cap_large * large_trucks;

% Objective
solve maximize total_snow;