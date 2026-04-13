% Parameters (with values embedded)
int: people_available = 100;
int: people_small = 1;
int: people_large = 3;
int: sand_small = 20;
int: sand_large = 50;
int: min_small = 5;
int: min_large = 3;
int: ratio_small_to_large = 3;

% Variables
var 0..people_available: small_containers;
var 0..(people_available div people_large): large_containers;
var 0..(people_available * max(sand_small, sand_large)): total_sand;

% Constraints
constraint small_containers >= min_small;
constraint large_containers >= min_large;

constraint small_containers = ratio_small_to_large * large_containers;

constraint people_small * small_containers + people_large * large_containers <= people_available;

constraint total_sand = sand_small * small_containers + sand_large * large_containers;

% Objective
solve maximize total_sand;