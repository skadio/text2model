% Parameters (with values embedded)
int: small_capacity = 20;
int: large_capacity = 50;
int: ore_required = 2000;
int: min_large = 10;

% Upper bounds (safe, derived from requirements)
int: max_large = ore_required div large_capacity;     % 40
int: max_small = ore_required div small_capacity;     % 100

% Variables
var 0..max_small: small_wagons;
var min_large..max_large: large_wagons;

% Constraints
constraint small_wagons >= 2 * large_wagons;
constraint small_wagons * small_capacity + large_wagons * large_capacity >= ore_required;

% Objective
solve minimize small_wagons + large_wagons;