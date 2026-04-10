% Parameters
int: total_med = 1000;
int: med_large = 3;
int: fill_large = 2;
int: med_small = 2;
int: fill_small = 1;
int: min_large = 100;
int: pct_small_num = 60; % 60%
int: pct_small_den = 100;

% Variables
var 0..(total_med div med_large): L; % number of large pills
var 0..(total_med div med_small): S; % number of small pills
var 0..(fill_large*(total_med div med_large) + fill_small*(total_med div med_small)): total_filler;

% Constraints
constraint L >= min_large;

% medicinal ingredient capacity
constraint med_large * L + med_small * S <= total_med;

% at least 60% of total pills are small: S >= 0.6*(L+S)  <=>  100*S >= 60*(L+S)
constraint pct_small_den * S >= pct_small_num * (L + S);

% define objective expression variable with explicit bounds
constraint total_filler = fill_large * L + fill_small * S;

% Objective
solve minimize total_filler;