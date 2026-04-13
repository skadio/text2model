% Parameters
int: gifts_per_trip_new = 50;          % Gifts delivered per trip by the new company
int: gifts_per_trip_old = 70;          % Gifts delivered per trip by the old company
int: diesel_per_trip_new = 30;         % Liters of diesel used per trip by the new company
int: diesel_per_trip_old = 40;         % Liters of diesel used per trip by the old company

int: min_total_gifts = 1000;           % Minimum total number of gifts to deliver
int: max_trips_new = 15;               % Maximum number of trips allowed for the new company
int: min_old_trip_percent = 40;        % Minimum percentage of all trips made by the old company

% Variables
var 0..max_trips_new: trips_new;       % Number of trips made by the new company
var 0..1000: trips_old;                % Number of trips made by the old company (safe upper bound)

var 0..100000: total_diesel;           % Total diesel used

% Constraints
% --- Total gifts delivery requirement ---
constraint
  gifts_per_trip_new * trips_new + gifts_per_trip_old * trips_old >= min_total_gifts;

% --- New company trip limit (already enforced by domain, restated for clarity) ---
constraint
  trips_new <= max_trips_new;

% --- Old company must perform at least 40% of all trips ---
% 100 * trips_old >= min_old_trip_percent * (trips_new + trips_old)
constraint
  100 * trips_old >= min_old_trip_percent * (trips_new + trips_old);

% --- Total diesel accounting ---
constraint
  total_diesel = diesel_per_trip_new * trips_new + diesel_per_trip_old * trips_old;

% Objective
solve minimize total_diesel;