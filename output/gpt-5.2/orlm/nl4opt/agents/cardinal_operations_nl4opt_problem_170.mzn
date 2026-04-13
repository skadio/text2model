% Parameters
int: small_capacity = 5;           % Honey units per small bottle
int: large_capacity = 20;          % Honey units per large bottle

int: max_small_available = 300;    % Maximum available small bottles
int: max_large_available = 100;    % Maximum available large bottles

int: max_total_bottles = 200;      % Maximum total bottles that can be transported
int: min_large_required = 50;      % Minimum large bottles required

% Variables
var 0..max_small_available: num_small;  % Number of small bottles to use
var 0..max_large_available: num_large;  % Number of large bottles to use

% Constraints

% Availability limits (already reflected in variable domains; kept for clarity/robustness)
constraint num_small <= max_small_available;
constraint num_large <= max_large_available;

% Selling preference: at least twice as many small bottles as large bottles
constraint num_small >= 2 * num_large;

% Transport capacity: at most max_total_bottles bottles in total
constraint num_small + num_large <= max_total_bottles;

% Minimum large bottles requirement
constraint num_large >= min_large_required;

% Objective
solve maximize small_capacity * num_small + large_capacity * num_large;