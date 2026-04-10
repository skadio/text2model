% Parameters
int: workers_available = 100;
int: workers_small = 2;
int: workers_large = 5;

int: capacity_small = 25;
int: capacity_large = 60;

int: min_small = 10;
int: min_large = 4;

int: ratio_small_per_large = 3;

% Variables
var min_small..(workers_available div workers_small): small_bins;
var min_large..(workers_available div workers_large): large_bins;
var 0..(capacity_small*(workers_available div workers_small) + capacity_large*(workers_available div workers_large)): total_capacity;

% Constraints
constraint workers_small * small_bins + workers_large * large_bins <= workers_available;

constraint small_bins = ratio_small_per_large * large_bins;

constraint total_capacity = capacity_small * small_bins + capacity_large * large_bins;

% Objective
solve maximize total_capacity;