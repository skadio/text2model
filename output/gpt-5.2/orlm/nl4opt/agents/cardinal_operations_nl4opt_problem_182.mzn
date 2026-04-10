% Parameters
int: ship_capacity = 40;          % Containers per ship trip
int: ship_fuel = 500;             % Fuel (liters) per ship trip
int: plane_capacity = 20;         % Containers per plane trip
int: plane_fuel = 300;            % Fuel (liters) per plane trip

int: min_containers = 500;        % Minimum total containers to transport
int: max_plane_trips = 10;        % Maximum number of plane trips allowed
int: min_ship_trip_fraction = 50; % Minimum % of trips that must be ships (integer percent)

% Variables
var 0..1000: ship_trips;             % Number of ship trips
var 0..max_plane_trips: plane_trips; % Number of plane trips
var 0..1000000: total_fuel;          % Total fuel consumed (liters)

% Constraints

% Link total fuel to the chosen number of trips
constraint
  total_fuel = ship_fuel * ship_trips + plane_fuel * plane_trips;

% Meet minimum transportation requirement (in containers)
constraint
  ship_capacity * ship_trips + plane_capacity * plane_trips >= min_containers;

% Plane trip limit (also enforced by variable domain, kept for clarity)
constraint
  plane_trips <= max_plane_trips;

% At least min_ship_trip_fraction percent of all trips must be by ship
% ship_trips / (ship_trips + plane_trips) >= min_ship_trip_fraction / 100
% Cross-multiplied to keep it linear and integer-safe:
constraint
  100 * ship_trips >= min_ship_trip_fraction * (ship_trips + plane_trips);

% Objective
solve minimize total_fuel;