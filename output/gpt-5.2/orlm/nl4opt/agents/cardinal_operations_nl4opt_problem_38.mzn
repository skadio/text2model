% Parameters
int: total_chickens = 1200;          % Total number of chickens to transport

int: bus_capacity = 100;             % Chickens per bus trip
int: car_capacity = 40;              % Chickens per car trip

float: bus_time = 2.0;               % Hours per bus trip
float: car_time = 1.5;               % Hours per car trip

int: max_bus_trips = 10;             % Maximum allowed number of bus trips
float: min_car_trip_fraction = 0.60; % Minimum fraction of all trips that must be by car


% Variables
var 0..max_bus_trips: bus_trips;     % Number of bus trips

% Upper bound: in worst case, all by car => ceil(1200/40)=30
var 0..30: car_trips;                % Number of car trips

var 0.0..1000.0: total_time;         % Total transport time (hours)


% Constraints

% --- Chicken transport requirement (meet or exceed total chickens) ---
constraint
  bus_trips * bus_capacity + car_trips * car_capacity >= total_chickens;

% --- Bus trip limit (redundant due to variable domain, kept for clarity) ---
constraint
  bus_trips <= max_bus_trips;

% --- At least 60% of all trips must be by car ---
% car_trips / (bus_trips + car_trips) >= min_car_trip_fraction
% Avoid division by cross-multiplying with integers:
constraint
  100 * car_trips >= ceil(min_car_trip_fraction * 100.0) * (bus_trips + car_trips);

% --- Define total time from trips and per-trip times ---
constraint
  total_time = bus_time * int2float(bus_trips) + car_time * int2float(car_trips);


% Objective
solve minimize total_time;