% Parameters
int: heli_capacity = 5;          % patients per helicopter trip
int: heli_time = 1;              % hours per helicopter trip
int: bus_capacity = 8;           % patients per bus trip
int: bus_time = 3;               % hours per bus trip
int: min_patients = 120;         % minimum number of patients to transport
int: max_bus_trips = 10;         % maximum number of bus trips allowed
int: min_heli_percent = 30;      % minimum percentage of trips that must be by helicopter

% Variables
var 0..min_patients: heli_trips; % safe upper bound: 120 heli trips can move 600 patients
var 0..max_bus_trips: bus_trips; % bus trips limited to at most 10
var 0..(heli_time*min_patients + bus_time*max_bus_trips): total_time; % total hours upper bound

% Constraints
% Transport at least the required number of patients
constraint
  heli_capacity * heli_trips + bus_capacity * bus_trips >= min_patients;

% Bus trip limit (redundant with domain, kept for clarity)
constraint
  bus_trips <= max_bus_trips;

% At least min_heli_percent% of trips are helicopter trips:
% 100*heli_trips >= min_heli_percent*(heli_trips + bus_trips)
constraint
  100 * heli_trips >= min_heli_percent * (heli_trips + bus_trips);

% Define total transport time
constraint
  total_time = heli_time * heli_trips + bus_time * bus_trips;

% Objective
solve minimize total_time;

% Optional output for readability
output [
  "heli_trips = ", show(heli_trips), "\n",
  "bus_trips  = ", show(bus_trips), "\n",
  "total_time = ", show(total_time), " hours\n",
  "patients_moved = ", show(heli_capacity*heli_trips + bus_capacity*bus_trips), "\n"
];