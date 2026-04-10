% Parameters
int: cap_small = 5;
int: cap_large = 20;

int: max_small_avail = 300;
int: max_large_avail = 100;

int: max_total_bottles = 200;
int: min_large_used = 50;

% Variables
var 0..max_small_avail: small;
var 0..max_large_avail: large;
var 0..(cap_small*max_small_avail + cap_large*max_large_avail): total_honey;

% Constraints
constraint small + large <= max_total_bottles;
constraint large >= min_large_used;
constraint small >= 2 * large;

constraint total_honey = cap_small * small + cap_large * large;

% Objective
solve maximize total_honey;