% Parameters (with values embedded)
int: small_capacity = 200;
int: large_capacity = 500;

int: max_small = 100;
int: max_large = 50;

int: max_total_crates = 60;
int: min_large = 10;

int: small_per_large_ratio = 3;

% Variables
var 0..max_small: small_crates;
var min_large..max_large: large_crates;

% Constraints
constraint small_crates >= small_per_large_ratio * large_crates;
constraint small_crates + large_crates <= max_total_crates;

% Objective
var int: total_grapes = small_capacity * small_crates + large_capacity * large_crates;

solve maximize total_grapes;