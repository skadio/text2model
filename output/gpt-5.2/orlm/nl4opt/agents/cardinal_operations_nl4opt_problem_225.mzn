% Parameters
int: total_monkeys = 300;                 % Total number of monkeys to transport

int: bus_capacity = 20;                   % Monkeys per bus trip
int: car_capacity = 6;                    % Monkeys per car trip

int: bus_time = 30;                       % Minutes per bus trip
int: car_time = 15;                       % Minutes per car trip

int: max_bus_trips = 10;                  % Maximum allowed bus trips

int: min_car_trip_percent = 60;           % Minimum percentage of trips that must be by car

% Derived bounds for variables (safe upper bound on car trips)
int: max_car_trips = total_monkeys div car_capacity + 1;

% Variables
var 0..max_bus_trips: bus_trips;          % Number of bus trips
var 0..max_car_trips: car_trips;          % Number of car trips

var 0..(bus_time*max_bus_trips + car_time*max_car_trips): total_time; % Total time (minutes)

% Constraints

% --- Capacity / demand satisfaction ---
% Ensure enough total transport capacity to move all monkeys
constraint
  bus_capacity * bus_trips + car_capacity * car_trips >= total_monkeys;

% --- Trip composition (minimum percentage by car) ---
% At least min_car_trip_percent% of all trips must be by car:
% car_trips / (bus_trips + car_trips) >= min_car_trip_percent / 100
% Cross-multiplied to stay in integers.
constraint
  100 * car_trips >= min_car_trip_percent * (bus_trips + car_trips);

% --- Total time definition ---
% Total time is the sum of time spent on bus and car trips
constraint
  total_time = bus_time * bus_trips + car_time * car_trips;

% Objective
solve minimize total_time;