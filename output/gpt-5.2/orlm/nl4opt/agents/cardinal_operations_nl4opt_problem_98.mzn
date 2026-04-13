% Parameters
int: heli_capacity = 5;          % patients per helicopter trip
int: heli_time = 1;              % hours per helicopter trip
int: bus_capacity = 8;           % patients per bus trip
int: bus_time = 3;               % hours per bus trip

int: min_patients = 120;         % at least this many patients must be transported
int: min_heli_percent = 30;      % at least this percent of all trips are helicopter trips
int: max_bus_trips = 10;         % at most this many bus trips are allowed

% Variables
var 0..(min_patients div heli_capacity + 100): heli_trips;  % number of helicopter trips
var 0..max_bus_trips: bus_trips;                             % number of bus trips (bounded)

var 0..(min_patients + bus_capacity*max_bus_trips): patients_transported; % total patients transported
var 0..100000: total_time;                                   % total transport time (hours)

% Constraints
%--- Total patients transported definition and minimum requirement ---
constraint
  patients_transported = heli_capacity * heli_trips + bus_capacity * bus_trips;

constraint
  patients_transported >= min_patients;

%--- Minimum percentage of trips by helicopter (avoid floats via cross-multiplication) ---
% heli_trips / (heli_trips + bus_trips) >= min_heli_percent / 100
constraint
  100 * heli_trips >= min_heli_percent * (heli_trips + bus_trips);

%--- Total time definition ---
constraint
  total_time = heli_time * heli_trips + bus_time * bus_trips;

% Objective
solve minimize total_time;