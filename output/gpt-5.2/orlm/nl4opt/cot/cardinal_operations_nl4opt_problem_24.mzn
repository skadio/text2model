% Parameters (with values embedded)
int: people_needed = 80;

int: cap_large = 6;
int: spots_large = 2;

int: cap_small = 2;
int: spots_small = 1;

int: min_small_units = 5;
int: large_pct_num = 75;  % at least 75%
int: large_pct_den = 100;

% Variables
var 0..people_needed: large_units;
var 0..people_needed: small_units;
var 0..people_needed * max(spots_large, spots_small): total_spots;

% Constraints
constraint cap_large * large_units + cap_small * small_units >= people_needed;

constraint small_units >= min_small_units;

% large_units >= 0.75 * (large_units + small_units)
constraint large_pct_den * large_units >= large_pct_num * (large_units + small_units);

constraint total_spots = spots_large * large_units + spots_small * small_units;

% Objective
solve minimize total_spots;