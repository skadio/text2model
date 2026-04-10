% Parameters
int: people_to_transport = 80;
int: cap_large = 6;
int: cap_small = 2;
int: spots_large = 2;
int: spots_small = 1;
int: min_small_units = 5;
int: min_large_fraction_pct = 75;

% Variables
var 0..people_to_transport: L; % number of large mobile production units
var 0..people_to_transport: S; % number of small mobile production units
var 0..(spots_large*people_to_transport + spots_small*people_to_transport): total_spots;

% Constraints
constraint S >= min_small_units;

constraint cap_large * L + cap_small * S >= people_to_transport;

% Large units must be at least 75% of all vehicles: L / (L+S) >= 0.75
% Equivalent linear form: 100*L >= 75*(L+S)  -> 25*L >= 75*S -> L >= 3*S
constraint L >= 3 * S;

constraint total_spots = spots_large * L + spots_small * S;

% Objective
solve minimize total_spots;