% Parameters (with values embedded)
int: total_medicinal = 1000;

int: med_large = 3;
int: filler_large = 2;

int: med_small = 2;
int: filler_small = 1;

int: min_large = 100;

% Variables
var 0..total_medicinal div med_large: x_large; % number of large pills
var 0..total_medicinal div med_small: x_small; % number of small pills

% Constraints
constraint x_large >= min_large;

% Medicinal ingredients limit
constraint med_large * x_large + med_small * x_small <= total_medicinal;

% At least 60% of total pills must be small:
% x_small >= 0.6 * (x_large + x_small)  <=>  2*x_small >= 3*x_large
constraint 2 * x_small >= 3 * x_large;

% Objective
var 0..filler_large * (total_medicinal div med_large) + filler_small * (total_medicinal div med_small): total_filler;
constraint total_filler = filler_large * x_large + filler_small * x_small;

solve minimize total_filler;