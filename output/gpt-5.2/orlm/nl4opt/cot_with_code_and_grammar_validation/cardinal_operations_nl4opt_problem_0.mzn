% Parameters
int: boat_capacity = 10;
int: canoe_capacity = 8;
int: boat_time = 20;
int: canoe_time = 40;

int: max_boat_trips = 12;
int: min_ducks = 300;

% At least 60% of trips by canoe: canoe >= 0.6*(boat+canoe) -> 2*canoe >= 3*boat
int: canoe_ratio_lhs = 2;
int: canoe_ratio_rhs = 3;

% Safe upper bounds for search
int: max_canoe_trips = 100;

% Variables
var 0..max_boat_trips: boat_trips;
var 0..max_canoe_trips: canoe_trips;

var 0..(boat_capacity * max_boat_trips + canoe_capacity * max_canoe_trips): total_ducks;
var 0..(boat_time * max_boat_trips + canoe_time * max_canoe_trips): total_time;

% Constraints
constraint total_ducks = boat_capacity * boat_trips + canoe_capacity * canoe_trips;
constraint total_ducks >= min_ducks;

constraint canoe_ratio_lhs * canoe_trips >= canoe_ratio_rhs * boat_trips;

constraint total_time = boat_time * boat_trips + canoe_time * canoe_trips;

% Objective
solve minimize total_time;