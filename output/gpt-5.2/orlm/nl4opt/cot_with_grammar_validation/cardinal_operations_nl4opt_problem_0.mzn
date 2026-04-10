% Parameters
int: boat_capacity = 10;
int: canoe_capacity = 8;
int: boat_time = 20;
int: canoe_time = 40;
int: max_boat_trips = 12;
int: min_ducks = 300;

% Variables
var 0..max_boat_trips: boat_trips;
var 0..1000: canoe_trips;

% Constraints
constraint boat_capacity * boat_trips + canoe_capacity * canoe_trips >= min_ducks;

% At least 60% of trips are by canoe:
% canoe_trips >= 0.6 * (boat_trips + canoe_trips)
% <=> 10*canoe_trips >= 6*(boat_trips + canoe_trips)
% <=> 4*canoe_trips >= 6*boat_trips
% <=> 2*canoe_trips >= 3*boat_trips
constraint 2 * canoe_trips >= 3 * boat_trips;

% Objective
solve minimize boat_time * boat_trips + canoe_time * canoe_trips;