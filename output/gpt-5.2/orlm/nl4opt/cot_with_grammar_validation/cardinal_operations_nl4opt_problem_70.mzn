% Parameters
int: gifts_per_trip_new = 50;
int: gifts_per_trip_old = 70;
int: diesel_per_trip_new = 30;
int: diesel_per_trip_old = 40;

int: min_gifts = 1000;
int: max_trips_new = 15;

% Variables
var 0..max_trips_new: trips_new;
var 0..1000: trips_old; % safe upper bound

% Constraints
constraint gifts_per_trip_new * trips_new + gifts_per_trip_old * trips_old >= min_gifts;

constraint trips_new <= max_trips_new;

% At least 40% of all trips are old:
% trips_old >= 0.4 * (trips_new + trips_old)  <=>  3*trips_old >= 2*trips_new
constraint 3 * trips_old >= 2 * trips_new;

% Objective
solve minimize diesel_per_trip_new * trips_new + diesel_per_trip_old * trips_old;