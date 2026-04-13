% Parameters
int: small_capacity = 50;              % snacks per small suitcase
int: large_capacity = 80;              % snacks per large suitcase

int: max_small = 70;                   % available small suitcases
int: max_large = 50;                   % available large suitcases
int: min_large = 15;                   % minimum large suitcases to send
int: max_total_suitcases = 70;         % maximum total suitcases to send
int: small_to_large_ratio = 2;         % at least this many small per large (small >= 2*large)

% Variables
var 0..max_small: num_small;           % number of small suitcases sent
var min_large..max_large: num_large;   % number of large suitcases sent
var 0..(small_capacity*max_small + large_capacity*max_large): total_snacks; % total snacks delivered

% Constraints
% Suitcase availability limits (already reflected in variable domains, kept for clarity)
constraint num_small <= max_small;
constraint num_large <= max_large;

% Minimum large suitcases requirement (already reflected in variable domain, kept for clarity)
constraint num_large >= min_large;

% Preference constraint: at least twice as many small suitcases as large suitcases
constraint num_small >= small_to_large_ratio * num_large;

% Total number of suitcases sent cannot exceed the allowed maximum
constraint num_small + num_large <= max_total_suitcases;

% Define total snacks delivered based on suitcase counts and capacities
constraint total_snacks = small_capacity * num_small + large_capacity * num_large;

% Objective
solve maximize total_snacks;