% Parameters
int: bus_capacity = 9;
int: car_capacity = 4;
int: min_children = 100;
int: min_cars = 5;

% Variables
var 0..ceil(int2float(min_children) / int2float(bus_capacity)): buses;
var min_cars..ceil(int2float(min_children) / int2float(car_capacity)): cars;

% Constraints
constraint bus_capacity * buses + car_capacity * cars >= min_children;
constraint buses > cars;

% Objective
solve minimize buses + cars;