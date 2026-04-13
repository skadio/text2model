% Parameters
int: small_capacity = 30;        % hot dogs/day produced by one small shop
int: large_capacity = 70;        % hot dogs/day produced by one large shop
int: small_workers = 2;          % workers required per small shop
int: large_workers = 4;          % workers required per large shop
int: min_hotdogs = 500;          % minimum required hot dogs/day
int: max_workers = 30;           % total available workers

% Helpful derived bounds for decision variables (from worker availability)
int: max_small_by_workers = max_workers div small_workers;  % upper bound from workers
int: max_large_by_workers = max_workers div large_workers;  % upper bound from workers

% Variables
var 0..max_small_by_workers: num_small_shops;   % number of small shops to build
var 0..max_large_by_workers: num_large_shops;   % number of large shops to build
var 0..(max_small_by_workers + max_large_by_workers): total_shops; % total shops built

% Constraints
% Link total number of shops to decision variables
constraint total_shops = num_small_shops + num_large_shops;

% Meet minimum daily hot dog production requirement
constraint small_capacity * num_small_shops + large_capacity * num_large_shops >= min_hotdogs;

% Do not exceed total available workers
constraint small_workers * num_small_shops + large_workers * num_large_shops <= max_workers;

% Objective
solve minimize total_shops;