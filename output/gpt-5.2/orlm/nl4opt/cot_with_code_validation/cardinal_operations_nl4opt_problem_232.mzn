% Parameters
int: people_available = 100;
int: small_people = 1;
int: large_people = 3;
int: small_capacity = 20;
int: large_capacity = 50;
int: ratio_small_to_large = 3;
int: min_small = 5;
int: min_large = 3;

% Variables
var int: small_containers;
var int: large_containers;
var int: total_sand;

% Constraints
constraint small_containers >= min_small;
constraint large_containers >= min_large;

constraint small_containers = ratio_small_to_large * large_containers;

constraint small_people * small_containers + large_people * large_containers <= people_available;

constraint total_sand = small_capacity * small_containers + large_capacity * large_containers;
constraint total_sand >= 0;

% Objective
solve maximize total_sand;