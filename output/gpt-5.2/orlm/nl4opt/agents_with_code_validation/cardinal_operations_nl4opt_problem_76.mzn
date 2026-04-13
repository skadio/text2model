% Parameters
int: small_keg_capacity = 40;          % liters per small keg
int: large_keg_capacity = 100;         % liters per large keg

int: max_small_kegs_available = 30;    % maximum small kegs available
int: max_large_kegs_available = 10;    % maximum large kegs available

int: max_total_kegs = 25;              % maximum total kegs that can be transported
int: min_large_kegs = 5;               % minimum large kegs required

int: small_to_large_ratio = 2;         % at least this many small kegs per large keg


% Variables
var 0..max_small_kegs_available: num_small_kegs;  % number of small kegs used
var 0..max_large_kegs_available: num_large_kegs;  % number of large kegs used

% Upper bound uses worst-case liters per keg (large) for max_total_kegs
var 0..(max_total_kegs * large_keg_capacity): total_liters; % total liters transported


% Constraints

% Total transported liters equals liters in small and large kegs
constraint
  total_liters =
    small_keg_capacity * num_small_kegs +
    large_keg_capacity * num_large_kegs;

% Availability limits
constraint num_small_kegs <= max_small_kegs_available;
constraint num_large_kegs <= max_large_kegs_available;

% Transport limit on total number of kegs
constraint num_small_kegs + num_large_kegs <= max_total_kegs;

% Minimum large kegs required
constraint num_large_kegs >= min_large_kegs;

% Ratio requirement: at least small_to_large_ratio small kegs per large keg
constraint num_small_kegs >= small_to_large_ratio * num_large_kegs;


% Objective
solve maximize total_liters;