% Parameters
int: max_total_vehicles = 1000;          % Maximum vehicles that can be assigned in total
int: min_vehicles_x = 400;              % Minimum vehicles required on route X
int: min_vehicles_y = 300;              % Minimum vehicles required on route Y
int: cost_per_vehicle_x = 50;           % Daily cost per vehicle on route X ($/day)
int: cost_per_vehicle_y = 60;           % Daily cost per vehicle on route Y ($/day)

% Variables
var min_vehicles_x..max_total_vehicles: vehicles_x;  % Vehicles assigned to route X
var min_vehicles_y..max_total_vehicles: vehicles_y;  % Vehicles assigned to route Y
var 0..(cost_per_vehicle_x*max_total_vehicles + cost_per_vehicle_y*max_total_vehicles): total_cost; % Total daily cost ($)

% Constraints
% Fleet capacity constraint: total vehicles assigned across both routes cannot exceed the limit
constraint
  vehicles_x + vehicles_y <= max_total_vehicles;

% Cost definition constraint: compute total daily cost from route allocations
constraint
  total_cost = cost_per_vehicle_x * vehicles_x + cost_per_vehicle_y * vehicles_y;

% Objective
solve minimize total_cost;