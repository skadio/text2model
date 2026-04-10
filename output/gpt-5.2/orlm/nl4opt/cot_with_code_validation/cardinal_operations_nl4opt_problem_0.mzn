% Parameters
int: boat_capacity = 10;
int: canoe_capacity = 8;

int: boat_time = 20;
int: canoe_time = 40;

int: max_boat_trips = 12;
float: min_canoe_frac = 0.60;

int: min_ducks = 300;

% Variables
var 0..max_boat_trips: boat_trips;
var 0..1000: canoe_trips;

var 0..100000: total_time;

% Constraints
constraint boat_capacity * boat_trips + canoe_capacity * canoe_trips >= min_ducks;

% At least 60% of trips by canoe:
% canoe_trips / (boat_trips + canoe_trips) >= 0.60
% => 0.40 * canoe_trips >= 0.60 * boat_trips
% Multiply by 10 to keep integers: 4 * canoe_trips >= 6 * boat_trips
constraint 4 * canoe_trips >= 6 * boat_trips;

constraint total_time = boat_time * boat_trips + canoe_time * canoe_trips;

% Objective
solve minimize total_time;