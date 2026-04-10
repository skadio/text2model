% Parameters
int: workers_available = 100;          % Total workers available
int: workers_per_small = 2;            % Workers needed per small bin
int: workers_per_large = 5;            % Workers needed per large bin
int: capacity_small = 25;              % Capacity (units) of a small bin
int: capacity_large = 60;              % Capacity (units) of a large bin
int: min_small_bins = 10;              % Minimum number of small bins
int: min_large_bins = 4;               % Minimum number of large bins
int: small_to_large_ratio = 3;         % Small bins must be this multiple of large bins

% Variables
var min_small_bins..(workers_available div workers_per_small): small_bins;  % Number of small bins
var min_large_bins..(workers_available div workers_per_large): large_bins;  % Number of large bins
var 0..(capacity_small * (workers_available div workers_per_small)
     + capacity_large * (workers_available div workers_per_large)): total_recycling; % Total collected units

% Constraints
% Worker availability constraint: total workers used by bins cannot exceed available workers
constraint
  workers_per_small * small_bins + workers_per_large * large_bins <= workers_available;

% Ratio constraint: number of small bins must be exactly three times the number of large bins
constraint
  small_bins = small_to_large_ratio * large_bins;

% Total recycling calculation: total collected units based on bin capacities
constraint
  total_recycling = capacity_small * small_bins + capacity_large * large_bins;

% Objective
solve maximize total_recycling;