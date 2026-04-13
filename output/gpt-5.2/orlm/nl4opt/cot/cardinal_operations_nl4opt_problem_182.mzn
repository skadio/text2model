% Parameters (with values embedded)
int: ship_capacity = 40;
int: plane_capacity = 20;
int: ship_fuel = 500;
int: plane_fuel = 300;

int: demand = 500;
int: max_plane_trips = 10;

% Variables
var 0..1000: ship_trips;
var 0..max_plane_trips: plane_trips;
var 0..1000000: total_fuel;

% Constraints
constraint ship_capacity * ship_trips + plane_capacity * plane_trips >= demand;

% At least 50% of all trips are ship trips:
% ship_trips / (ship_trips + plane_trips) >= 0.5  <=>  ship_trips >= plane_trips
constraint ship_trips >= plane_trips;

constraint total_fuel = ship_fuel * ship_trips + plane_fuel * plane_trips;

% Objective
solve minimize total_fuel;