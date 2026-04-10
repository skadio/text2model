% Parameters
int: plane_capacity = 10;
int: truck_capacity = 6;

int: plane_cost = 1000;
int: truck_cost = 700;

int: min_tires = 200;
int: budget = 22000;

% Upper bounds from budget
int: max_plane_trips = budget div plane_cost;
int: max_truck_trips = budget div truck_cost;

% Variables
var 0..max_plane_trips: plane_trips;
var 0..max_truck_trips: truck_trips;
var 0..(max_plane_trips + max_truck_trips): total_trips;

% Constraints
constraint plane_capacity * plane_trips + truck_capacity * truck_trips >= min_tires;
constraint plane_cost * plane_trips + truck_cost * truck_trips <= budget;
constraint plane_trips <= truck_trips;
constraint total_trips = plane_trips + truck_trips;

% Objective
solve minimize total_trips;