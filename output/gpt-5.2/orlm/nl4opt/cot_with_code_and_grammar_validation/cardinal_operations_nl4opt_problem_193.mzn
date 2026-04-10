% Parameters
int: cap_small = 20;
int: cap_large = 50;
int: min_students = 500;
float: max_large_frac = 0.20;

% Variables
var 0..min_students: n_small;
var 0..min_students: n_large;
var 0..2*min_students: n_total;

% Constraints
constraint n_total = n_small + n_large;

constraint cap_small * n_small + cap_large * n_large >= min_students;

% At most 20% of buses can be large: n_large <= 0.2 * n_total
% Avoid floats by multiplying: 5*n_large <= n_total
constraint 5 * n_large <= n_total;

% Objective
solve minimize n_total;