include "globals.mzn";

% Data (embedded from problem statement)
int: gifts_per_trip_new = 50;
int: gifts_per_trip_old = 70;

int: diesel_per_trip_new = 30;
int: diesel_per_trip_old = 40;

int: min_gifts = 1000;
int: max_new_trips = 15;

% At least 40% of all trips must be old:
% old_trips / (old_trips + new_trips) >= 0.4
% <=> 5*old_trips >= 2*(old_trips + new_trips) <=> 3*old_trips >= 2*new_trips
int: pct_num = 3;
int: pct_den = 2;

% Decision variables
var 0..max_new_trips: new_trips;
var 0..ceil(min_gifts div gifts_per_trip_old) + max_new_trips: old_trips;

% Constraints
constraint gifts_per_trip_new * new_trips + gifts_per_trip_old * old_trips >= min_gifts;
constraint pct_num * old_trips >= pct_den * new_trips;

% Objective: minimize diesel usage
var int: total_diesel = diesel_per_trip_new * new_trips + diesel_per_trip_old * old_trips;

solve minimize total_diesel;

output [
  "new_trips = ", show(new_trips), "\n",
  "old_trips = ", show(old_trips), "\n",
  "total_gifts = ", show(gifts_per_trip_new * new_trips + gifts_per_trip_old * old_trips), "\n",
  "total_diesel = ", show(total_diesel), "\n"
];