% Parameters
int: small_capacity = 30;          % Hot dogs/day produced by a small shop
int: large_capacity = 70;          % Hot dogs/day produced by a large shop
int: small_workers = 2;            % Workers required for a small shop
int: large_workers = 4;            % Workers required for a large shop
int: demand = 500;                 % Minimum hot dogs/day required
int: workers_available = 30;       % Total workers available

% Derived bounds (for variable bounding)
int: max_small_by_workers = workers_available div small_workers; % Upper bound by worker limit
int: max_large_by_workers = workers_available div large_workers; % Upper bound by worker limit

% Variables
var 0..max_small_by_workers: n_small;   % Number of small shops to build
var 0..max_large_by_workers: n_large;   % Number of large shops to build

% Constraints
% Production demand: total daily hot dog output must meet or exceed the required demand
constraint small_capacity * n_small + large_capacity * n_large >= demand;

% Worker availability: total workers used by all shops cannot exceed those available
constraint small_workers * n_small + large_workers * n_large <= workers_available;

% Objective
solve minimize n_small + n_large;