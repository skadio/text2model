% Parameters
int: heli_capacity = 5;
int: heli_time = 1;
int: bus_capacity = 8;
int: bus_time = 3;

int: min_patients = 120;
int: max_bus_trips = 10;

% at least 30% of trips are helicopter: h / (h + b) >= 0.3  <=>  7h >= 3b
int: heli_ratio_num = 3;
int: heli_ratio_den = 10;

% Upper bounds for search (safe bounds)
int: max_heli_trips = (min_patients div heli_capacity) + bus_capacity * max_bus_trips;

% Variables
var 0..max_heli_trips: h;        % number of helicopter trips
var 0..max_bus_trips: b;         % number of bus trips
var 0..(heli_time * max_heli_trips + bus_time * max_bus_trips): total_time;

% Constraints
constraint heli_capacity * h + bus_capacity * b >= min_patients;
constraint b <= max_bus_trips;

% helicopter trips ratio constraint: h/(h+b) >= 0.3, avoiding division
constraint (heli_ratio_den - heli_ratio_num) * h >= heli_ratio_num * b;

constraint total_time = heli_time * h + bus_time * b;

% Objective
solve minimize total_time;