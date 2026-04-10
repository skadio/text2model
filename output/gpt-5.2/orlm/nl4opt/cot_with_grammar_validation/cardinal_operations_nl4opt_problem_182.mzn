% Parameters
int: ship_capacity = 40;
int: ship_fuel = 500;
int: plane_capacity = 20;
int: plane_fuel = 300;

int: min_containers = 500;
int: max_plane_trips = 10;

% Variables
var 0..ceil(min_containers / ship_capacity): ship_trips;
var 0..max_plane_trips: plane_trips;

% Constraints
constraint ship_capacity * ship_trips + plane_capacity * plane_trips >= min_containers;

% At least 50% of trips are by ship:
% ship_trips >= 0.5 * (ship_trips + plane_trips)  <=>  ship_trips >= plane_trips
constraint ship_trips >= plane_trips;

% Objective
solve minimize ship_fuel * ship_trips + plane_fuel * plane_trips;