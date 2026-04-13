% Parameters
int: required_chickens = 1200;
int: bus_capacity = 100;
int: car_capacity = 40;

float: bus_time = 2.0;
float: car_time = 1.5;

int: max_bus_trips = 10;

% At least 60% of trips are by car  =>  car_trips >= 0.6*(bus_trips+car_trips)
% Use integer form: 10*car_trips >= 6*(bus_trips+car_trips)  <=> 4*car_trips >= 6*bus_trips
int: car_frac_num = 6;
int: car_frac_den = 10;

% Variables
var 0..max_bus_trips: bus_trips;
var 0..required_chickens div car_capacity + 100: car_trips;

var int: total_trips;
var int: transported;

var float: total_time;

% Constraints
constraint total_trips = bus_trips + car_trips;
constraint transported = bus_trips * bus_capacity + car_trips * car_capacity;
constraint transported >= required_chickens;

constraint car_frac_den * car_trips >= car_frac_num * total_trips;

constraint total_time = bus_time * int2float(bus_trips) + car_time * int2float(car_trips);

% Objective
solve minimize total_time;