% Parameters
int: cap_small = 5;
int: cap_large = 20;

int: max_small_avail = 300;
int: max_large_avail = 100;

int: max_total_bottles = 200;
int: min_large_used = 50;

% Variables
var 0..max_small_avail: small_used;
var 0..max_large_avail: large_used;
var 0..(cap_small * max_small_avail + cap_large * max_large_avail): total_honey;

% Constraints
constraint small_used + large_used <= max_total_bottles;
constraint large_used >= min_large_used;
constraint small_used >= 2 * large_used;

constraint total_honey = cap_small * small_used + cap_large * large_used;

% Objective
solve maximize total_honey;