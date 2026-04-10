% Parameters (with values embedded)
int: heli_capacity = 5;
int: heli_time = 1;
int: bus_capacity = 8;
int: bus_time = 3;

int: patients_required = 120;
int: max_bus_trips = 10;

% At least 30% of trips are helicopter:
% heli_trips / (heli_trips + bus_trips) >= 0.30
% => 10*heli_trips >= 3*(heli_trips + bus_trips) => 7*heli_trips >= 3*bus_trips
int: heli_ratio_num_lhs = 7;
int: heli_ratio_num_rhs = 3;

% Safe upper bound for helicopter trips: if all patients by helicopter
int: max_heli_trips = patients_required;  % 120 trips is certainly sufficient as an upper bound

% Variables
var 0..max_heli_trips: heli_trips;
var 0..max_bus_trips: bus_trips;

var 0..(heli_time*max_heli_trips + bus_time*max_bus_trips): total_time;

% Constraints
constraint heli_capacity * heli_trips + bus_capacity * bus_trips >= patients_required;
constraint bus_trips <= max_bus_trips;

% 7*heli_trips >= 3*bus_trips enforces >=30% helicopter trips (including bus_trips=0 allowed)
constraint heli_ratio_num_lhs * heli_trips >= heli_ratio_num_rhs * bus_trips;

constraint total_time = heli_time * heli_trips + bus_time * bus_trips;

% Objective
solve minimize total_time;