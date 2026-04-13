% Parameters
int: total_medicinal = 1000;
int: med_per_large = 3;
int: fill_per_large = 2;
int: med_per_small = 2;
int: fill_per_small = 1;

int: min_large = 100;

% Represent 60% as an exact fraction to avoid floats: small / (large+small) >= 3/5
int: pop_num = 3;
int: pop_den = 5;

% Variables
var 0..(total_medicinal div med_per_large): large;
var 0..(total_medicinal div med_per_small): small;
var 0..(fill_per_large*(total_medicinal div med_per_large) + fill_per_small*(total_medicinal div med_per_small)): total_filler;

% Constraints
constraint large >= min_large;

constraint med_per_large * large + med_per_small * small <= total_medicinal;

% At least 60% of total pills are small: small >= 0.6*(large+small)
% Using exact fraction: 5*small >= 3*(large+small)  <=> 2*small >= 3*large
constraint pop_den * small >= pop_num * (large + small);

constraint total_filler = fill_per_large * large + fill_per_small * small;

% Objective
solve minimize total_filler;