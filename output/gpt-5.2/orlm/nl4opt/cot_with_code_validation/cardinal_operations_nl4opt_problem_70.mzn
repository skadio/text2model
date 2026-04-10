% Parameters
int: gifts_per_trip_new = 50;
int: gifts_per_trip_old = 70;
int: diesel_per_trip_new = 30;
int: diesel_per_trip_old = 40;

int: min_gifts = 1000;
int: max_trips_new = 15;

int: pct_old_num = 40; % 40%
int: pct_old_den = 100;

% Upper bounds (safe, derived)
int: max_trips_old = (min_gifts div gifts_per_trip_old) + 50; % safe buffer
int: max_total_trips = max_trips_new + max_trips_old;

% Variables
var 0..max_trips_new: trips_new;
var 0..max_trips_old: trips_old;
var 0..max_total_trips: total_trips;
var 0..(diesel_per_trip_new * max_trips_new + diesel_per_trip_old * max_trips_old): total_diesel;

% Constraints
constraint total_trips = trips_new + trips_old;

constraint gifts_per_trip_new * trips_new + gifts_per_trip_old * trips_old >= min_gifts;

% At least 40% of all trips are old:
% trips_old / total_trips >= 0.4  ->  100*trips_old >= 40*total_trips
constraint pct_old_den * trips_old >= pct_old_num * total_trips;

constraint total_diesel = diesel_per_trip_new * trips_new + diesel_per_trip_old * trips_old;

% Objective
solve minimize total_diesel;