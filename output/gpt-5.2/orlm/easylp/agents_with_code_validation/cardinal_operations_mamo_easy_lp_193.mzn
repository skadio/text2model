% Parameters
int: max_vehicles = 1000;          % Maximum total vehicles available
int: min_x = 300;                 % Minimum vehicles required on route X
int: min_y = 200;                 % Minimum vehicles required on route Y
int: min_z = 150;                 % Minimum vehicles required on route Z

int: cost_x = 3;                  % Cost per vehicle on route X
int: cost_y = 2;                  % Cost per vehicle on route Y
int: cost_z = 5;                  % Cost per vehicle on route Z

% Variables
var 0..max_vehicles: vehicles_x;   % Vehicles allocated to route X
var 0..max_vehicles: vehicles_y;   % Vehicles allocated to route Y
var 0..max_vehicles: vehicles_z;   % Vehicles allocated to route Z

% Total cost (in dollars), bounded by allocating all vehicles at each route cost
var 0..(cost_x*max_vehicles + cost_y*max_vehicles + cost_z*max_vehicles): total_cost;

% Constraints
% Demand satisfaction constraints (minimum vehicles per route)
constraint vehicles_x >= min_x;
constraint vehicles_y >= min_y;
constraint vehicles_z >= min_z;

% Fleet capacity constraint (total vehicles cannot exceed availability)
constraint vehicles_x + vehicles_y + vehicles_z <= max_vehicles;

% Cost accounting constraint (define total_cost from route allocations)
constraint total_cost = cost_x * vehicles_x + cost_y * vehicles_y + cost_z * vehicles_z;

% Objective
solve minimize total_cost;

output [
  "vehicles_x=", show(vehicles_x), "\n",
  "vehicles_y=", show(vehicles_y), "\n",
  "vehicles_z=", show(vehicles_z), "\n",
  "total_cost=$", show(total_cost), "\n"
];