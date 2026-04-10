% Parameters
int: bus_capacity = 9;              % Children a bus can carry
int: car_capacity = 4;              % Children a personal car can carry
int: min_children = 100;            % Minimum number of children to pick up
int: min_cars = 5;                  % At least this many personal cars required

% Precomputed bounds for variable domains (avoid float/ceil on var expressions)
int: max_buses = (min_children + bus_capacity - 1) div bus_capacity;
int: max_cars  = (min_children + car_capacity - 1) div car_capacity;

% Variables
var 0..max_buses: buses;                 % Number of buses scheduled
var min_cars..max_cars: cars;            % Number of personal cars scheduled
var 0..(max_buses + max_cars): total_vehicles; % Total number of vehicles

% Constraints
% Total vehicles definition
constraint total_vehicles = buses + cars;

% Minimum children pickup requirement (capacity constraint)
constraint bus_capacity * buses + car_capacity * cars >= min_children;

% Pollution limitation: must have more buses than personal cars
constraint buses > cars;

% Extra attention requirement: at least a minimum number of personal cars
constraint cars >= min_cars;

% Objective
solve minimize total_vehicles;