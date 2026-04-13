% Parameters
int: ship_capacity = 40;              % Containers per ship trip
int: ship_fuel = 500;                 % Fuel (liters) per ship trip
int: plane_capacity = 20;             % Containers per plane trip
int: plane_fuel = 300;                % Fuel (liters) per plane trip

int: min_containers = 500;            % Minimum containers to transport
int: max_plane_trips = 10;            % Maximum number of plane trips
float: min_ship_trip_fraction = 0.5;  % Minimum fraction of trips that are ship trips

% Variables
var 0..ceil(min_containers / ship_capacity): ship_trips; % Number of ship trips
var 0..max_plane_trips: plane_trips;                     % Number of plane trips
var 0..(ship_fuel * ceil(min_containers / ship_capacity) + plane_fuel * max_plane_trips): total_fuel;
% Total fuel used (liters)

% Constraints
% --- Capacity requirement: transport at least the minimum number of containers ---
constraint
  ship_capacity * ship_trips + plane_capacity * plane_trips >= min_containers;

% --- Plane trip limit (also enforced by the variable domain) ---
constraint
  plane_trips <= max_plane_trips;

% --- Minimum fraction of trips must be by ship ---
% ship_trips / (ship_trips + plane_trips) >= min_ship_trip_fraction
% Cross-multiplied using floats to avoid integer division issues:
constraint
  int2float(ship_trips) >= min_ship_trip_fraction * int2float(ship_trips + plane_trips);

% --- Define total fuel used ---
constraint
  total_fuel = ship_fuel * ship_trips + plane_fuel * plane_trips;

% Objective
solve minimize total_fuel;