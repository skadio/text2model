% Parameters
int: demand = 1800;
int: max_pollution = 2000;

set of int: T = 1..4; % 1=truck, 2=van, 3=motorcycle, 4=ev

array[T] of int: cap = [100, 80, 40, 60];
array[T] of int: pol = [100, 50, 10, 0];

int: min_truck_trips = 10;

% Variables
array[T] of var 0..demand: trips; % safe upper bound
var 0..max_pollution: total_pollution;

% Constraints
constraint trips[1] >= min_truck_trips;

% Either vans or electric vehicles, but not both
constraint (trips[2] = 0) \/ (trips[4] = 0);

% Meet demand (at least 1800 units delivered)
constraint sum(t in T)(cap[t] * trips[t]) >= demand;

% Pollution accounting and limit
constraint total_pollution = sum(t in T)(pol[t] * trips[t]);
constraint total_pollution <= max_pollution;

% Objective
solve minimize total_pollution;