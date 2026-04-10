% Parameters
int: small_capacity = 40;
int: large_capacity = 100;

int: max_small_available = 30;
int: max_large_available = 10;

int: max_total_kegs = 25;
int: min_large_kegs = 5;

int: small_at_least_times_large = 2;

% Variables
var 0..max_small_available: small_kegs;
var 0..max_large_available: large_kegs;

var 0..(small_capacity * max_small_available + large_capacity * max_large_available): total_liters;

% Constraints
constraint small_kegs + large_kegs <= max_total_kegs;
constraint large_kegs >= min_large_kegs;
constraint small_kegs >= small_at_least_times_large * large_kegs;

constraint total_liters = small_capacity * small_kegs + large_capacity * large_kegs;

% Objective
solve maximize total_liters;