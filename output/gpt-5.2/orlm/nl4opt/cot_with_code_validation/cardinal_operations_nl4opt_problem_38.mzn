% Parameters
int: required_chickens = 1200;
int: bus_capacity = 100;
int: car_capacity = 40;

int: max_bus_trips = 10;

int: bus_time_num = 2;  % hours
int: bus_time_den = 1;

int: car_time_num = 3;  % 1.5 hours = 3/2
int: car_time_den = 2;

% Upper bound for car trips: if no buses, need ceil(1200/40)=30 trips
int: max_car_trips = (required_chickens + car_capacity - 1) div car_capacity;

% Variables
var 0..max_bus_trips: bus_trips;
var 0..max_car_trips: car_trips;

% Constraints
constraint bus_capacity * bus_trips + car_capacity * car_trips >= required_chickens;

% At least 60% of trips must be by car:
% car_trips / (bus_trips + car_trips) >= 0.6  <=>  5*car_trips >= 3*(bus_trips+car_trips)  <=>  2*car_trips >= 3*bus_trips
constraint 2 * car_trips >= 3 * bus_trips;

% Objective
% Minimize total time; use a common denominator (2):
% total_time = 2*bus_trips + 1.5*car_trips = (4*bus_trips + 3*car_trips)/2
% Minimizing numerator suffices.
solve minimize 4 * bus_trips + 3 * car_trips;