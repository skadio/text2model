% Parameters
int: total_chickens = 1200;

int: bus_capacity = 100;
int: car_capacity = 40;

int: max_bus_trips = 10;

float: bus_time = 2.0;
float: car_time = 1.5;

int: percent_car_min = 60; % at least 60% of all trips must be by car

% Variables
var 0..max_bus_trips: bus_trips;
var 0..total_chickens div car_capacity + 1: car_trips; % safe upper bound

var float: total_time;

% Constraints
constraint bus_capacity * bus_trips + car_capacity * car_trips >= total_chickens;

% car_trips / (bus_trips + car_trips) >= 0.60
% Avoid division: 100*car_trips >= 60*(bus_trips + car_trips)
constraint 100 * car_trips >= percent_car_min * (bus_trips + car_trips);

constraint total_time = bus_time * int2float(bus_trips) + car_time * int2float(car_trips);

% Objective
solve minimize total_time;