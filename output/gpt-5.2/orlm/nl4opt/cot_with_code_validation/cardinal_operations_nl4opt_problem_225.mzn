% Parameters
int: monkeys = 300;
int: bus_cap = 20;
int: car_cap = 6;
int: bus_time = 30;
int: car_time = 15;
int: max_bus_trips = 10;
int: car_trip_pct = 60; % at least 60% of trips are by car

% Variables
var 0..max_bus_trips: bus_trips;
var 0..monkeys: car_trips;

var 0..monkeys: total_trips;
var 0..(bus_time * max_bus_trips + car_time * monkeys): total_time;

% Constraints
constraint total_trips = bus_trips + car_trips;

constraint bus_cap * bus_trips + car_cap * car_trips >= monkeys;

% At least car_trip_pct% of trips by car: car_trips / total_trips >= car_trip_pct/100
% Avoid division: 100*car_trips >= car_trip_pct * total_trips
constraint total_trips >= 1;
constraint 100 * car_trips >= car_trip_pct * total_trips;

constraint total_time = bus_time * bus_trips + car_time * car_trips;

% Objective
solve minimize total_time;