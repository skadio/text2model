% Parameters
int: bus_capacity = 9;              % Children a bus can carry
int: car_capacity = 4;              % Children a personal car can carry
int: min_children = 100;            % Minimum children to pick up
int: min_cars = 5;                  % At least this many personal cars required

% Variables
var 0..ceil(min_children / bus_capacity): buses;          % Number of buses scheduled
var min_cars..ceil(min_children / car_capacity): cars;    % Number of personal cars scheduled
var 0..(ceil(min_children / bus_capacity) + ceil(min_children / car_capacity)): total_vehicles;

% Constraints
%--- Demand satisfaction: total pickup capacity must cover at least min_children
constraint
  bus_capacity * buses + car_capacity * cars >= min_children;

%--- Pollution/operational rule: strictly more buses than personal cars
constraint
  buses > cars;

%--- Total vehicles definition (for objective/use elsewhere)
constraint
  total_vehicles = buses + cars;

% Objective
solve minimize total_vehicles;