% Parameters
int: max_total_trucks = 500;          % Maximum number of trucks available for both routes combined
int: min_trucks_x = 100;              % Minimum trucks required on route X
int: min_trucks_y = 200;              % Minimum trucks required on route Y
int: cost_per_truck_x = 10;           % Cost per truck assigned to route X (dollars)
int: cost_per_truck_y = 20;           % Cost per truck assigned to route Y (dollars)

% Variables
var min_trucks_x..max_total_trucks: trucks_x;   % Integer trucks allocated to route X
var min_trucks_y..max_total_trucks: trucks_y;   % Integer trucks allocated to route Y
var 0..(max_total_trucks * max(cost_per_truck_x, cost_per_truck_y)): total_cost; % Total operational cost (dollars)

% Constraints
% Fleet size limit: total trucks assigned across both routes cannot exceed availability
constraint
  trucks_x + trucks_y <= max_total_trucks;

% Total cost definition: compute operational cost from allocations
constraint
  total_cost = cost_per_truck_x * trucks_x + cost_per_truck_y * trucks_y;

% Objective
solve minimize total_cost;