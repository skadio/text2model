% Parameters
int: monkeys = 300;
int: bus_cap = 20;
int: car_cap = 6;
int: bus_time = 30;
int: car_time = 15;
int: max_bus_trips = 10;
float: min_car_share = 0.60;

% Variables
var 0..max_bus_trips: bus_trips;
var 0..monkeys: car_trips; % safe upper bound

var 0..(bus_time * max_bus_trips + car_time * monkeys): total_time;

% Constraints
constraint bus_cap * bus_trips + car_cap * car_trips >= monkeys;

constraint bus_trips + car_trips > 0;

% At least 60% of trips are by car: car_trips / (bus_trips+car_trips) >= 0.60
% Equivalent linear form: 10*car_trips >= 6*(bus_trips+car_trips)  => 4*car_trips >= 6*bus_trips
constraint 4 * car_trips >= 6 * bus_trips;

constraint total_time = bus_time * bus_trips + car_time * car_trips;

% Objective
solve minimize total_time;