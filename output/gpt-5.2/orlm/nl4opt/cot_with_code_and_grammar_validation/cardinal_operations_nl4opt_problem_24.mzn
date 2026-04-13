% Parameters
int: people_needed = 80;
int: cap_large = 6;
int: cap_small = 2;
int: spots_large = 2;
int: spots_small = 1;
int: min_small_units = 5;
int: pct_large_min_num = 75;
int: pct_large_min_den = 100;

% Variables
var 0..people_needed: L; % number of large mobile production units
var 0..people_needed: S; % number of small mobile production units
var 0..(spots_large*people_needed + spots_small*people_needed): total_spots;

% Constraints
constraint cap_large * L + cap_small * S >= people_needed;

constraint S >= min_small_units;

% Large must be at least 75% of all vehicles: L / (L+S) >= 0.75
% Avoid division: 100*L >= 75*(L+S)
constraint pct_large_min_den * L >= pct_large_min_num * (L + S);

constraint total_spots = spots_large * L + spots_small * S;

% Objective
solve minimize total_spots;