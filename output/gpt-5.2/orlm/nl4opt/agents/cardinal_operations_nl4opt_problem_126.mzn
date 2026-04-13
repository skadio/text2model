% Parameters
int: flowers_per_small = 5;         % flowers in one small bouquet
int: flowers_per_large = 10;        % flowers in one large bouquet

int: max_small_bouquets = 80;       % upper bound on small bouquets
int: max_large_bouquets = 50;       % upper bound on large bouquets
int: max_total_bouquets = 70;       % upper bound on total bouquets

int: min_large_bouquets = 20;       % minimum required large bouquets
int: small_at_least_factor = 2;     % small bouquets must be at least this multiple of large

% Variables
var 0..max_small_bouquets: small_bouquets;   % number of small bouquets transported
var 0..max_large_bouquets: large_bouquets;   % number of large bouquets transported

var 0..(flowers_per_small*max_small_bouquets + flowers_per_large*max_large_bouquets): total_flowers;

% Constraints
% Total bouquets capacity constraint
constraint
  small_bouquets + large_bouquets <= max_total_bouquets;

% Minimum large bouquets requirement
constraint
  large_bouquets >= min_large_bouquets;

% Popularity constraint: small bouquets at least a multiple of large
constraint
  small_bouquets >= small_at_least_factor * large_bouquets;

% Define total flowers transported
constraint
  total_flowers = flowers_per_small * small_bouquets + flowers_per_large * large_bouquets;

% Objective
solve maximize total_flowers;