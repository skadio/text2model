% Parameters
int: max_vehicles = 1000;          % Total vehicles available across all routes
int: min_X = 300;                 % Minimum vehicles required on route X
int: min_Y = 200;                 % Minimum vehicles required on route Y
int: min_Z = 150;                 % Minimum vehicles required on route Z
int: cost_X = 3;                  % Cost per vehicle on route X (dollars)
int: cost_Y = 2;                  % Cost per vehicle on route Y (dollars)
int: cost_Z = 5;                  % Cost per vehicle on route Z (dollars)

% Variables
var 0..max_vehicles: vehicles_X;   % Vehicles allocated to route X
var 0..max_vehicles: vehicles_Y;   % Vehicles allocated to route Y
var 0..max_vehicles: vehicles_Z;   % Vehicles allocated to route Z
var 0..(max_vehicles * max([cost_X, cost_Y, cost_Z])): total_cost; % Total cost (dollars)

% Constraints
%--- Fleet availability constraint (total vehicles across all routes) ---
constraint vehicles_X + vehicles_Y + vehicles_Z <= max_vehicles;

%--- Minimum demand constraints per route ---
constraint vehicles_X >= min_X;
constraint vehicles_Y >= min_Y;
constraint vehicles_Z >= min_Z;

%--- Total cost definition constraint (link total_cost to allocations) ---
constraint total_cost =
    cost_X * vehicles_X +
    cost_Y * vehicles_Y +
    cost_Z * vehicles_Z;

% Objective
solve minimize total_cost;