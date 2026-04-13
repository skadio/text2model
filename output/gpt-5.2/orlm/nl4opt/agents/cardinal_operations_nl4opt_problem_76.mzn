% Parameters
int: small_capacity = 40;          % liters per small keg
int: large_capacity = 100;         % liters per large keg

int: max_small_available = 30;     % at most 30 small kegs available
int: max_large_available = 10;     % at most 10 large kegs available
int: max_total_kegs = 25;          % at most 25 kegs total
int: min_large_used = 5;           % at least 5 large kegs must be used
int: small_to_large_ratio = 2;     % small kegs used must be at least 2x large kegs used

% Variables
var 0..max_small_available: num_small_kegs;  % number of small kegs used
var 0..max_large_available: num_large_kegs;  % number of large kegs used
var 0..(max_total_kegs * max(small_capacity, large_capacity)): total_liters; % total liters transported

% Constraints
% Capacity calculation: total liters transported from chosen kegs
constraint
  total_liters = small_capacity * num_small_kegs + large_capacity * num_large_kegs;

% Availability limits (redundant with variable domains but kept for clarity)
constraint num_small_kegs <= max_small_available;
constraint num_large_kegs <= max_large_available;

% Total number of kegs carried cannot exceed maximum allowed
constraint
  num_small_kegs + num_large_kegs <= max_total_kegs;

% Minimum number of large kegs required
constraint
  num_large_kegs >= min_large_used;

% Small kegs must be at least 'small_to_large_ratio' times the large kegs
constraint
  num_small_kegs >= small_to_large_ratio * num_large_kegs;

% Objective
solve maximize total_liters;

output [
  "num_small_kegs = ", show(num_small_kegs), "\n",
  "num_large_kegs = ", show(num_large_kegs), "\n",
  "total_liters = ", show(total_liters), "\n"
];