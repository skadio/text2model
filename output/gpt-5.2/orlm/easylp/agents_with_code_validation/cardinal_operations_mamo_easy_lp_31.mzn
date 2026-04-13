% Parameters
float: cost_X = 0.5;
float: cost_Y = 1.0;

int: max_total_trips = 10000;
int: min_trips_X = 3000;
int: min_trips_Y = 2000;

% Variables (whole numbers of trips)
var min_trips_X..max_total_trips: trips_X;
var min_trips_Y..max_total_trips: trips_Y;

% Work in cents to avoid float-to-int conversion issues
var int: total_cost_cents;
var int: total_cost_rounded_dollars;

% Constraints
constraint trips_X + trips_Y <= max_total_trips;

% Total cost in cents: 0.5 dollars = 50 cents, 1 dollar = 100 cents
constraint total_cost_cents = 50 * trips_X + 100 * trips_Y;

% Rounded to nearest dollar (100 cents): floor((cents + 50) / 100)
constraint total_cost_rounded_dollars = (total_cost_cents + 50) div 100;

% Objective
solve minimize total_cost_rounded_dollars;

output [
  "trips_X = ", show(trips_X), "\n",
  "trips_Y = ", show(trips_Y), "\n",
  "total_cost_rounded_dollars = ", show(total_cost_rounded_dollars), "\n"
];