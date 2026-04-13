include "globals.mzn";

% Data (embedded as requested)
int: bus_capacity = 9;
int: car_capacity = 4;
int: min_children = 100;

% Constraints
int: min_cars = 5;
% "more buses than personal cars"
% buses >= cars + 1

% Decision variables
var 0..1000: buses;
var 0..1000: cars;

% At least 100 children can be picked up
constraint bus_capacity * buses + car_capacity * cars >= min_children;

% More buses than cars (strictly)
constraint buses >= cars + 1;

% At least 5 personal cars
constraint cars >= min_cars;

% Objective: minimize total number of vehicles
var 0..2000: total_vehicles = buses + cars;

solve minimize total_vehicles;

output [
  "buses = ", show(buses), "\n",
  "cars = ", show(cars), "\n",
  "total_vehicles = ", show(total_vehicles), "\n",
  "children_capacity = ", show(bus_capacity*buses + car_capacity*cars), "\n"
];