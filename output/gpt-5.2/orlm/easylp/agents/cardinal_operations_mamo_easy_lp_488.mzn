% Parameters
% Total available resources across both divisions
int: max_total_resources = 10000;

% Minimum required strategic objective: 2*X + Y >= this value
int: min_strategic_requirement = 6000;

% Maximum allowed imbalance: |X - Y| <= this value
int: max_allocation_difference = 2000;

% Cost per unit resource for each division (in dollars)
int: cost_per_unit_x = 5000;
int: cost_per_unit_y = 3000;


% Variables
% Whole-number resource allocations to divisions X and Y
var 0..max_total_resources: resources_x;
var 0..max_total_resources: resources_y;

% Total cost (in dollars), bounded by worst-case allocation
var 0..(max_total_resources * max(cost_per_unit_x, cost_per_unit_y)): total_cost;


% Constraints
% Total resources limit across both divisions: X + Y <= max_total_resources
constraint
  resources_x + resources_y <= max_total_resources;

% Strategic requirement: 2*X + Y >= min_strategic_requirement
constraint
  2 * resources_x + resources_y >= min_strategic_requirement;

% Balance/imbalance constraint: |X - Y| <= max_allocation_difference
constraint
  abs(resources_x - resources_y) <= max_allocation_difference;

% Define total cost based on allocations and per-unit costs
constraint
  total_cost = cost_per_unit_x * resources_x + cost_per_unit_y * resources_y;


% Objective
solve minimize total_cost;

output [
  "resources_x = ", show(resources_x), "\n",
  "resources_y = ", show(resources_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];