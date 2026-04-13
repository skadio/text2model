% Parameters
int: max_total_capacity = 2000;        % Maximum combined allocation for routes X and Y
int: min_alloc_x = 800;               % Minimum required allocation for route X
int: min_alloc_y = 500;               % Minimum required allocation for route Y
int: cost_per_unit_x = 50;            % Cost per unit allocated to route X (dollars)
int: cost_per_unit_y = 30;            % Cost per unit allocated to route Y (dollars)

% Variables
var min_alloc_x..max_total_capacity: alloc_x;   % Allocation to route X (units, integer)
var min_alloc_y..max_total_capacity: alloc_y;   % Allocation to route Y (units, integer)
var 0..(cost_per_unit_x*max_total_capacity + cost_per_unit_y*max_total_capacity): total_cost;
                                                % Total cost (dollars)

% Constraints
% Capacity constraint: total allocation across both routes cannot exceed infrastructure limit
constraint
  alloc_x + alloc_y <= max_total_capacity;

% Cost definition: total cost equals per-unit costs times allocations
constraint
  total_cost = cost_per_unit_x * alloc_x + cost_per_unit_y * alloc_y;

% Objective
solve minimize total_cost;