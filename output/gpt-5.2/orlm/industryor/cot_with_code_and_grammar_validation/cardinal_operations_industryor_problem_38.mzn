% Parameters
int: n_methods = 3;
set of int: METHODS = 1..n_methods;

% Index mapping: 1=motorcycle, 2=small_truck, 3=large_truck
array[METHODS] of int: pollution_per_trip = [40, 70, 100];
array[METHODS] of int: capacity_per_trip  = [10, 20, 50];

int: min_total_capacity = 300;
int: max_total_trips = 20;

int: max_motorcycle_trips = 8;

% Variables
array[METHODS] of var 0..max_total_trips: trips;
array[METHODS] of var bool: used;

% Constraints
constraint forall(m in METHODS) (
  used[m] <-> (trips[m] >= 1)
);

constraint sum(m in METHODS)(bool2int(used[m])) = 2;

constraint trips[1] <= max_motorcycle_trips;

constraint sum(m in METHODS)(trips[m]) <= max_total_trips;

constraint sum(m in METHODS)(capacity_per_trip[m] * trips[m]) >= min_total_capacity;

% Objective
solve minimize sum(m in METHODS)(pollution_per_trip[m] * trips[m]);