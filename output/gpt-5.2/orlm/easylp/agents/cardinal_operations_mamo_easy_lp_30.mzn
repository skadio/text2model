% Parameters
% Maximum total number of vehicles allowed
int: max_vehicles = 50;

% Minimum required combined capacity (3*X + 2*Y)
int: min_capacity = 100;

% Capacity contribution coefficients
int: cap_per_x = 3;
int: cap_per_y = 2;

% Fuel consumption per vehicle
int: fuel_per_x = 2;
int: fuel_per_y = 3;

% Variables
% Number of vehicles of type X (integer, non-negative, bounded by max_vehicles)
var 0..max_vehicles: num_x;

% Number of vehicles of type Y (integer, non-negative, bounded by max_vehicles)
var 0..max_vehicles: num_y;

% Total fuel consumption (integer, bounded by a safe upper bound)
var 0..(max_vehicles * max(fuel_per_x, fuel_per_y)): total_fuel;

% Constraints
% Vehicle count limit: cannot exceed the maximum allowed total vehicles
constraint
  num_x + num_y <= max_vehicles;

% Minimum combined capacity requirement: 3*X + 2*Y must meet demand
constraint
  cap_per_x * num_x + cap_per_y * num_y >= min_capacity;

% Total fuel accounting: define total_fuel from chosen numbers of vehicles
constraint
  total_fuel = fuel_per_x * num_x + fuel_per_y * num_y;

% Objective
solve minimize total_fuel;