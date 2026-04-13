% Parameters (with values embedded)
int: tires_per_plane = 10;
int: cost_per_plane = 1000;
int: tires_per_truck = 6;
int: cost_per_truck = 700;

int: min_tires = 200;
int: budget = 22000;

% Variables
var 0..(budget div cost_per_plane): plane_trips;
var 0..(budget div cost_per_truck): truck_trips;

var 0..((budget div cost_per_plane) + (budget div cost_per_truck)): total_trips;

% Constraints
constraint tires_per_plane * plane_trips + tires_per_truck * truck_trips >= min_tires;
constraint cost_per_plane * plane_trips + cost_per_truck * truck_trips <= budget;
constraint plane_trips <= truck_trips;

constraint total_trips = plane_trips + truck_trips;

% Objective
solve minimize total_trips;