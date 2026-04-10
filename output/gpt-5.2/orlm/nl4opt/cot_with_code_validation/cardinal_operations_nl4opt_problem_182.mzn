% Parameters
int: ship_capacity = 40;
int: ship_fuel = 500;
int: plane_capacity = 20;
int: plane_fuel = 300;

int: min_containers = 500;
int: max_plane_trips = 10;

% Variables
var 0..ceil(min_containers div ship_capacity) + max_plane_trips: ship_trips;
var 0..max_plane_trips: plane_trips;

var 0..(ship_fuel*(ceil(min_containers div ship_capacity) + max_plane_trips) + plane_fuel*max_plane_trips): total_fuel;

% Constraints
constraint ship_capacity * ship_trips + plane_capacity * plane_trips >= min_containers;

constraint plane_trips <= max_plane_trips;

% Minimum 50% of trips are ships: ship_trips >= 0.5*(ship_trips + plane_trips)
% Equivalent integer form: ship_trips >= plane_trips
constraint ship_trips >= plane_trips;

constraint total_fuel = ship_fuel * ship_trips + plane_fuel * plane_trips;

% Objective
solve minimize total_fuel;