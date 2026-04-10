% Parameters
int: small_capacity = 5;            % Honey units per small bottle
int: large_capacity = 20;           % Honey units per large bottle

int: max_small_available = 300;     % Maximum small bottles available
int: max_large_available = 100;     % Maximum large bottles available

int: max_total_bottles = 200;       % Maximum total bottles that can be transported
int: min_large_required = 50;       % Minimum large bottles that must be used

int: small_to_large_ratio = 2;      % At least this many small bottles per large bottle

% Variables
var 0..max_small_available: n_small;  % Number of small bottles used
var 0..max_large_available: n_large;  % Number of large bottles used

var 0..(max_total_bottles * large_capacity): total_honey; % Total honey transported (units)

% Constraints
% --- Availability bounds (already captured by variable domains, but stated for clarity) ---
constraint
  n_small <= max_small_available /\ n_large <= max_large_available;

% --- Transport limit: at most a certain number of bottles total ---
constraint
  n_small + n_large <= max_total_bottles;

% --- Minimum large bottles requirement ---
constraint
  n_large >= min_large_required;

% --- Sales preference: at least 'small_to_large_ratio' times as many small as large ---
constraint
  n_small >= small_to_large_ratio * n_large;

% --- Define total honey transported from chosen bottles ---
constraint
  total_honey = small_capacity * n_small + large_capacity * n_large;

% Objective
solve maximize total_honey;