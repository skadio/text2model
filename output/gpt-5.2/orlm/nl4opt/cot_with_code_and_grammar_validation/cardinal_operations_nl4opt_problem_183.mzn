% Parameters
int: cap_large = 2000;
int: cap_small = 800;
int: pol_large = 20;
int: pol_small = 15;

int: max_large_trips = 7;
int: min_customers = 20000;

% Variables
var 0..max_large_trips: L;          % number of large trips
var 0..100: S;                      % number of small trips (upper bound tightened by constraints below)

% Constraints
constraint cap_large * L + cap_small * S >= min_customers;

% At least 40% of total trips are small: S / (L+S) >= 0.4  <=> 3S >= 2L
constraint 3 * S >= 2 * L;

% Tighten bounds for S given customer requirement and max L
constraint S <= (min_customers div cap_small) + cap_large; % safe redundant bound
constraint S <= 25; % since even with L=0, need at most 25 small trips to reach 20000

% Objective
solve minimize pol_large * L + pol_small * S;