% Parameters
int: people_available = 100;
int: small_unload_people = 1;
int: large_unload_people = 3;
int: small_capacity = 20;
int: large_capacity = 50;
int: ratio_small_per_large = 3;
int: min_small = 5;
int: min_large = 3;

% Variables
var int: large; % number of large containers
var int: small; % number of small containers
var int: total_sand;

% Constraints
constraint large >= min_large;
constraint small >= min_small;

% ratio: small = 3 * large
constraint small = ratio_small_per_large * large;

% people availability
constraint small_unload_people * small + large_unload_people * large <= people_available;

% total sand delivered
constraint total_sand = small_capacity * small + large_capacity * large;

% Objective
solve maximize total_sand;