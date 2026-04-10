% Parameters
int: n_methods = 3;                          % number of transport methods
set of int: METHODS = 1..n_methods;          % index set for methods

% Method indices for readability
int: MOTORCYCLE = 1;
int: SMALL_TRUCK = 2;
int: LARGE_TRUCK = 3;

array[METHODS] of int: pollution = [40, 70, 100];     % pollution units per trip
array[METHODS] of int: capacity  = [10, 20, 50];      % product units per trip

int: max_motorcycle_trips = 8;               % road restriction
int: min_total_products   = 300;             % demand to transport
int: max_total_trips      = 20;              % overall trip limit
int: max_methods_used     = 2;               % can choose only 2 methods

% Variables
array[METHODS] of var 0..max_total_trips: trips;   % number of trips by each method
array[METHODS] of var bool: used;                  % whether a method is chosen/used
var 0..(max_total_trips * 100): total_pollution;   % total pollution (bounded)

% Constraints

% Link "used" indicators with whether trips are taken (channeling constraints)
constraint
  forall(m in METHODS) (
    used[m] <-> (trips[m] > 0)
  );

% Limit the number of transportation methods used to at most 2
constraint
  sum(m in METHODS)(bool2int(used[m])) <= max_methods_used;

% Road restriction: motorcycle trips cannot exceed the given maximum
constraint
  trips[MOTORCYCLE] <= max_motorcycle_trips;

% Total number of trips across all methods must not exceed the overall limit
constraint
  sum(m in METHODS)(trips[m]) <= max_total_trips;

% Demand satisfaction: transport at least the minimum required total products
constraint
  sum(m in METHODS)(capacity[m] * trips[m]) >= min_total_products;

% Define total pollution based on number of trips and pollution per trip
constraint
  total_pollution = sum(m in METHODS)(pollution[m] * trips[m]);

% Objective
solve minimize total_pollution;