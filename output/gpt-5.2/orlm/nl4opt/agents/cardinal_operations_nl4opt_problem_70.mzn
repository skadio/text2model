% Parameters
int: gifts_per_trip_new = 50;          % Gifts delivered per trip by the new company
int: gifts_per_trip_old = 70;          % Gifts delivered per trip by the old company
int: diesel_per_trip_new = 30;         % Liters of diesel used per trip by the new company
int: diesel_per_trip_old = 40;         % Liters of diesel used per trip by the old company

int: min_total_gifts = 1000;           % Minimum number of gifts to deliver
int: max_trips_new = 15;               % Maximum number of trips allowed for the new company
float: min_fraction_old_trips = 0.4;   % Minimum fraction of all trips that must be old-company trips

% Variables
var 0..max_trips_new: trips_new;       % Trips made by the new company
var 0..1000: trips_old;                % Trips made by the old company (safe upper bound)

var 0..100000: total_diesel;           % Total diesel used (liters)

% Constraints
% --- Total gifts delivered must meet demand ---
constraint
  gifts_per_trip_new * trips_new + gifts_per_trip_old * trips_old >= min_total_gifts;

% --- Trip limit for the new company (already enforced by variable domain, kept for clarity) ---
constraint
  trips_new <= max_trips_new;

% --- At least 40% of all trips must be made by the old company ---
% old / (old + new) >= 0.4  <=>  old >= 0.4*(old+new)
% Use integer-safe form: 10*old >= 4*(old+new) <=> 6*old >= 4*new
constraint
  6 * trips_old >= 4 * trips_new;

% --- Define total diesel used ---
constraint
  total_diesel = diesel_per_trip_new * trips_new + diesel_per_trip_old * trips_old;

% Objective
solve minimize total_diesel;