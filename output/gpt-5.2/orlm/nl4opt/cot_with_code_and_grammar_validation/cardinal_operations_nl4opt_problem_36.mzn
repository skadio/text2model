% Parameters
int: workers_available = 100;

int: workers_small = 2;
int: workers_large = 5;

int: cap_small = 25;
int: cap_large = 60;

int: min_small = 10;
int: min_large = 4;

int: ratio_small_per_large = 3;

% Variables
var 0..workers_available: small_bins;
var 0..workers_available: large_bins;

var 0..(cap_small * workers_available + cap_large * workers_available): total_collected;

% Constraints
constraint small_bins >= min_small;
constraint large_bins >= min_large;

constraint small_bins = ratio_small_per_large * large_bins;

constraint workers_small * small_bins + workers_large * large_bins <= workers_available;

constraint total_collected = cap_small * small_bins + cap_large * large_bins;

% Objective
solve maximize total_collected;