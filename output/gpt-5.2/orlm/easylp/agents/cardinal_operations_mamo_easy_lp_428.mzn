% Parameters
int: total_capacity = 2000;          % Maximum combined allocation for routes X and Y
int: min_x = 800;                    % Minimum allocation required for route X
int: min_y = 500;                    % Minimum allocation required for route Y
int: cost_x = 50;                    % Cost per unit allocated to route X (dollars)
int: cost_y = 30;                    % Cost per unit allocated to route Y (dollars)

% Variables
var min_x..total_capacity: alloc_x;  % Integer allocation to route X
var min_y..total_capacity: alloc_y;  % Integer allocation to route Y
var 0..(total_capacity * max(cost_x, cost_y)): total_cost; % Total cost (dollars)

% Constraints
% Capacity constraint: combined allocation to routes X and Y cannot exceed total capacity
constraint alloc_x + alloc_y <= total_capacity;

% Cost definition constraint: total cost is the sum of per-unit costs for each route
constraint total_cost = cost_x * alloc_x + cost_y * alloc_y;

% Objective
solve minimize total_cost;

output [
  "alloc_x = ", show(alloc_x), "\n",
  "alloc_y = ", show(alloc_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];