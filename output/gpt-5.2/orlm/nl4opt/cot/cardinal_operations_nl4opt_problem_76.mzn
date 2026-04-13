% Parameters (with values embedded)
int: cap_small = 40;
int: cap_large = 100;

int: max_small = 30;
int: max_large = 10;

int: max_total_kegs = 25;
int: min_large = 5;

% Variables
var 0..max_small: small_kegs;
var 0..max_large: large_kegs;
var 0..(cap_small*max_small + cap_large*max_large): total_liters;

% Constraints
constraint total_liters = cap_small * small_kegs + cap_large * large_kegs;

constraint small_kegs <= max_small;
constraint large_kegs <= max_large;

constraint small_kegs + large_kegs <= max_total_kegs;
constraint large_kegs >= min_large;

% at least twice as many small kegs as large kegs
constraint small_kegs >= 2 * large_kegs;

% Objective
solve maximize total_liters;