% Parameters
int: gifts_per_trip_new = 50;
int: gifts_per_trip_old = 70;
int: diesel_per_trip_new = 30;
int: diesel_per_trip_old = 40;

int: min_gifts = 1000;
int: max_trips_new = 15;
int: min_old_trip_fraction_num = 40; % percent
int: min_old_trip_fraction_den = 100; % percent base

% Variables
var 0..max_trips_new: trips_new;
var 0..1000: trips_old; % safe upper bound; tightened by constraints below

% Constraints
constraint gifts_per_trip_new * trips_new + gifts_per_trip_old * trips_old >= min_gifts;

constraint trips_new <= max_trips_new;

% At least 40% of all trips are by the old company:
% trips_old / (trips_new + trips_old) >= 0.4
% 100*trips_old >= 40*(trips_new + trips_old)  => 60*trips_old >= 40*trips_new
constraint (min_old_trip_fraction_den - min_old_trip_fraction_num) * trips_old
          >= min_old_trip_fraction_num * trips_new;

% Strengthen bounds for trips_old
constraint trips_old <= ceil(int2float(min_gifts) / int2float(gifts_per_trip_old)) + max_trips_new;

% Objective
solve minimize diesel_per_trip_new * trips_new + diesel_per_trip_old * trips_old;