% Parameters
int: flowers_per_small = 5;              % flowers in a small bouquet
int: flowers_per_large = 10;             % flowers in a large bouquet

int: max_small_bouquets = 80;            % maximum small bouquets that can be transported
int: max_large_bouquets = 50;            % maximum large bouquets that can be transported
int: max_total_bouquets = 70;            % maximum total bouquets that can be transported

int: min_large_bouquets = 20;            % minimum large bouquets required
int: small_to_large_ratio = 2;           % must have at least this many small per large (small >= 2*large)

% Variables
var 0..max_small_bouquets: num_small;    % number of small bouquets transported
var 0..max_large_bouquets: num_large;    % number of large bouquets transported

% Constraints
% Capacity limits for each bouquet type (already reflected in variable domains, kept for clarity)
constraint num_small <= max_small_bouquets;
constraint num_large <= max_large_bouquets;

% Total bouquet transport limit
constraint num_small + num_large <= max_total_bouquets;

% Minimum required number of large bouquets
constraint num_large >= min_large_bouquets;

% Popularity requirement: at least twice as many small bouquets as large bouquets
constraint num_small >= small_to_large_ratio * num_large;

% Objective
solve maximize flowers_per_small * num_small + flowers_per_large * num_large;