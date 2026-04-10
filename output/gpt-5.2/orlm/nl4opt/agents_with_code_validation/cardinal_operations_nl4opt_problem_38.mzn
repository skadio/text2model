% Parameters
int: total_chickens = 1200;          % Total number of chickens to transport

int: bus_capacity = 100;             % Chickens per bus trip
float: bus_time_per_trip = 2.0;      % Hours per bus trip
int: max_bus_trips = 10;             % Maximum allowed bus trips

int: car_capacity = 40;              % Chickens per car trip
float: car_time_per_trip = 1.5;      % Hours per car trip
float: min_car_trip_fraction = 0.60; % Minimum fraction of trips that must be by car (embedded in constraint)

% Variables
var 0..max_bus_trips: bus_trips;     % Number of bus trips

% Upper bound: if only cars are used, trips needed = ceil(1200/40) = 30
var 0..30: car_trips;                % Number of car trips

var float: total_time;               % Total time in hours


% Constraints

% --- Transport enough chickens (capacity constraint) ---
constraint
  bus_trips * bus_capacity + car_trips * car_capacity >= total_chickens;

% --- Bus trip limit (already implied by variable domain, kept for clarity) ---
constraint
  bus_trips <= max_bus_trips;

% --- At least 60% of all trips must be by car ---
% car_trips / (bus_trips + car_trips) >= 0.60
% Linearized to avoid division:
% 100*car_trips >= 60*(bus_trips + car_trips)  <=>  40*car_trips >= 60*bus_trips
constraint
  40 * car_trips >= 60 * bus_trips;

% --- Define total time from the chosen trips ---
constraint
  total_time = bus_time_per_trip * int2float(bus_trips)
             + car_time_per_trip * int2float(car_trips);


% Objective
solve minimize total_time;