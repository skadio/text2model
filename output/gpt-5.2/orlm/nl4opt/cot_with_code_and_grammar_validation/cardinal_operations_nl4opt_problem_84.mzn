% Parameters
int: bus_capacity = 9;
int: car_capacity = 4;
int: min_children = 100;
int: min_cars = 5;

% Variables
var 0..min_children: buses;
var min_cars..min_children: cars;
var 0..2*min_children: total_vehicles;

% Constraints
constraint bus_capacity * buses + car_capacity * cars >= min_children;
constraint buses > cars;
constraint total_vehicles = buses + cars;

% Objective
solve minimize total_vehicles;