% Parameters
int: heli_capacity = 5;
int: heli_time = 1;
int: bus_capacity = 8;
int: bus_time = 3;

int: min_patients = 120;
float: min_heli_trip_ratio = 0.30;
int: max_bus_trips = 10;

% Variables
var 0..1000: h; % number of helicopter trips
var 0..max_bus_trips: b; % number of bus trips

% Constraints
constraint heli_capacity * h + bus_capacity * b >= min_patients;

% At least 30% of trips are by helicopter: h / (h+b) >= 0.30
% Linearized: 10*h >= 3*(h+b)  =>  7*h >= 3*b
constraint 7 * h >= 3 * b;

% Objective
var 0..100000: total_time;
constraint total_time = heli_time * h + bus_time * b;

solve minimize total_time;