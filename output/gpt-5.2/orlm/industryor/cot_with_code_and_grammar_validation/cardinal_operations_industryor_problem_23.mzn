% Parameters
int: demand = 1800;
int: max_pollution = 2000;

set of int: V = 1..4; % 1=truck, 2=van, 3=motorcycle, 4=EV

array[V] of int: capacity = [100, 80, 40, 60];
array[V] of int: pollution = [100, 50, 10, 0];

int: min_truck_trips = 10;

% Variables
array[V] of var 0..1000: trips; % number of trips per vehicle type (bounded sufficiently)

var 0..max_pollution: total_pollution;
var demand..100000: total_delivered;

% Constraints
constraint total_pollution = sum(v in V)(pollution[v] * trips[v]);
constraint total_delivered = sum(v in V)(capacity[v] * trips[v]);

constraint total_delivered >= demand;
constraint total_pollution <= max_pollution;

constraint trips[1] >= min_truck_trips;

% Either vans or EVs, but not both (mutual exclusivity)
constraint (trips[2] = 0) \/ (trips[4] = 0);

% Objective
solve minimize total_pollution;