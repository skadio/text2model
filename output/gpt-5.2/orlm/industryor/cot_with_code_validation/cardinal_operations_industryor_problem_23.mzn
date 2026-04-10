% Parameters
int: demand = 1800;
int: maxPollution = 2000;

set of int: T = 1..4; % 1=truck, 2=van, 3=motorcycle, 4=ev

array[T] of int: cap = [100, 80, 40, 60];
array[T] of int: pol = [100, 50, 10, 0];

int: minTruckTrips = 10;

% Upper bounds (safe, derived from demand and minimum capacity)
int: UB_trips = ceil(demand / min(cap));

% Variables
array[T] of var 0..UB_trips: trips;

% Constraints
constraint sum(t in T)(cap[t] * trips[t]) >= demand;

constraint sum(t in T)(pol[t] * trips[t]) <= maxPollution;

constraint trips[1] >= minTruckTrips;

% Either vans or EVs, but not both (mutual exclusivity)
constraint trips[2] = 0 \/ trips[4] = 0;

% Objective
var 0..maxPollution: totalPollution = sum(t in T)(pol[t] * trips[t]);
solve minimize totalPollution;