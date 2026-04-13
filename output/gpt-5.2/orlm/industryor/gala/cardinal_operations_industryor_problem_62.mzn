include "globals.mzn";

% Data (embedded)
int: demand = 1000;

int: cap_horse = 55;
int: cap_bike  = 30;
int: cap_cart  = 40;

int: pol_horse = 80;
int: pol_bike  = 0;
int: pol_cart  = 0;

int: pol_limit = 1000;
int: min_horse_trips = 8;

% Decision variables: number of trips by each method
var 0..1000: trips_horse;
var 0..1000: trips_bike;
var 0..1000: trips_cart;

% Binary choice: choose exactly one of {bicycle, handcart}
var 0..1: use_bike;
var 0..1: use_cart;

% Constraints
constraint use_bike + use_cart = 1;

% If not chosen, trips must be zero; if chosen, trips bounded by a safe upper bound
int: UB = 1000; % safe upper bound on any trip count
constraint trips_bike <= UB * use_bike;
constraint trips_cart <= UB * use_cart;

% Minimum horse usage
constraint trips_horse >= min_horse_trips;

% Pollution limit
var 0..1000000: total_pollution =
  pol_horse * trips_horse + pol_bike * trips_bike + pol_cart * trips_cart;
constraint total_pollution <= pol_limit;

% Demand satisfaction
var 0..1000000: total_transported =
  cap_horse * trips_horse + cap_bike * trips_bike + cap_cart * trips_cart;
constraint total_transported >= demand;

% Objective: minimize pollution
solve minimize total_pollution;

output [
  "Trips (horse, bicycle, handcart) = (",
  show(trips_horse), ", ", show(trips_bike), ", ", show(trips_cart), ")\n",
  "Chosen demanding method: ",
  if fix(use_bike) = 1 then "bicycle" else "handcart" endif, "\n",
  "Total transported = ", show(total_transported), "\n",
  "Total pollution = ", show(total_pollution), "\n"
];