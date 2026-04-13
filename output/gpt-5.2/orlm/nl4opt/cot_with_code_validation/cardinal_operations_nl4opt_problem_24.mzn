% Parameters
int: people_needed = 80;
int: cap_large = 6;
int: spots_large = 2;
int: cap_small = 2;
int: spots_small = 1;
int: min_small_units = 5;
int: large_pct_num = 75;  % at least 75%
int: large_pct_den = 100;

% Variables
var 0..people_needed: L;  % number of large units
var 0..people_needed: S;  % number of small units
var 0..(spots_large * people_needed + spots_small * people_needed): total_spots;

% Constraints
constraint S >= min_small_units;

constraint cap_large * L + cap_small * S >= people_needed;

% Large units must be at least 75% of all units: L/(L+S) >= 0.75
% Avoid division by cross-multiplying:
constraint large_pct_den * L >= large_pct_num * (L + S);

constraint total_spots = spots_large * L + spots_small * S;

% Objective
solve minimize total_spots;