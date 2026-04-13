% Parameters
int: small_capacity = 200;              % grapes per small crate
int: large_capacity = 500;              % grapes per large crate

int: max_small_available = 100;         % maximum small crates available
int: max_large_available = 50;          % maximum large crates available
int: max_total_crates = 60;             % truck capacity in total crates
int: min_large_required = 10;           % minimum large crates that must be used
int: small_to_large_ratio = 3;          % at least this many small per large

% Variables
var 0..max_small_available: n_small;    % number of small crates used
var 0..max_large_available: n_large;    % number of large crates used
var 0..(max_small_available*small_capacity + max_large_available*large_capacity): total_grapes;

% Constraints
% Total grapes carried equals sum of grapes in small and large crates
constraint
  total_grapes = n_small * small_capacity + n_large * large_capacity;

% Availability limits for each crate type (domains already enforce upper bounds)
constraint
  n_small <= max_small_available;
constraint
  n_large <= max_large_available;

% Truck capacity: total number of crates cannot exceed truck limit
constraint
  n_small + n_large <= max_total_crates;

% Minimum required number of large crates
constraint
  n_large >= min_large_required;

% Customer preference: at least 3 times as many small crates as large crates
constraint
  n_small >= small_to_large_ratio * n_large;

% Objective
solve maximize total_grapes;