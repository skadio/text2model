% Parameters (with values embedded)
int: max_total_trips = 10000;
int: min_trips_X = 3000;
int: min_trips_Y = 2000;
float: cost_X = 0.5;
float: cost_Y = 1.0;

% Variables
var 0..max_total_trips: trips_X;
var 0..max_total_trips: trips_Y;
var float: total_cost;

% Constraints
constraint trips_X >= min_trips_X;
constraint trips_Y >= min_trips_Y;
constraint trips_X + trips_Y <= max_total_trips;

constraint total_cost = cost_X * int2float(trips_X) + cost_Y * int2float(trips_Y);

% Objective
solve minimize total_cost;

output [
  "trips_X = ", show(trips_X), "\n",
  "trips_Y = ", show(trips_Y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "total_cost_rounded = ", show(fix(total_cost + 0.5)), "\n"
];