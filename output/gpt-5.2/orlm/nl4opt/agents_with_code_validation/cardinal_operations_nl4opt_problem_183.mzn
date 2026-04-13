% Parameters
int: capacity_large = 2000;          % customers per large trip
int: capacity_small = 800;           % customers per small trip
int: pollution_large = 20;           % pollution units per large trip
int: pollution_small = 15;           % pollution units per small trip

int: max_large_trips = 7;            % maximum number of large trips
int: min_small_share_pct = 40;       % at least 40% of total trips must be small
int: min_customers = 20000;          % minimum customers to transport

% Upper bound for small trips derived from meeting demand with only small ships (safe bound).
int: max_small_trips = (min_customers + capacity_small - 1) div capacity_small;

% Variables
var 0..max_large_trips: num_large_trips;  % number of large cruise ship trips
var 0..max_small_trips: num_small_trips;  % number of small cruise ship trips

% Constraints

% Demand satisfaction: total transported customers must meet or exceed the minimum
constraint
  capacity_large * num_large_trips + capacity_small * num_small_trips >= min_customers;

% Trip mix requirement: at least min_small_share_pct percent of all trips are small
% Enforced without division to avoid non-integer ratios:
% 100 * small >= pct * (large + small)
constraint
  100 * num_small_trips >= min_small_share_pct * (num_large_trips + num_small_trips);

% Feasibility guard: to satisfy the share constraint, there must be at least one trip
constraint
  num_large_trips + num_small_trips >= 1;

% Objective
solve minimize (pollution_large * num_large_trips + pollution_small * num_small_trips);