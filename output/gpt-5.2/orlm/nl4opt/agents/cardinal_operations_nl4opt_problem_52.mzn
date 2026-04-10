% Parameters
int: small_capacity = 50;            % snacks per small suitcase
int: large_capacity = 80;            % snacks per large suitcase

int: max_small = 70;                 % at most available small suitcases
int: max_large = 50;                 % at most available large suitcases
int: min_large = 15;                 % must send at least this many large suitcases
int: max_total_suitcases = 70;       % can send at most this many suitcases total

% Variables
var 0..max_small: n_small;           % number of small suitcases to send
var 0..max_large: n_large;           % number of large suitcases to send
var 0..(small_capacity*max_small + large_capacity*max_large): total_snacks; % total snacks delivered

% Constraints
% Link total snacks to the number of suitcases of each type
constraint total_snacks = small_capacity * n_small + large_capacity * n_large;

% Availability limits for suitcases (redundant with variable domains, kept for clarity)
constraint n_small <= max_small;
constraint n_large <= max_large;

% Customer preference: at least twice as many small suitcases as large suitcases
constraint n_small >= 2 * n_large;

% Minimum number of large suitcases to be shipped
constraint n_large >= min_large;

% Total number of suitcases shipped cannot exceed the maximum allowed
constraint n_small + n_large <= max_total_suitcases;

% Objective
solve maximize total_snacks;