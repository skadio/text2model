% Parameters
int: max_total_resources = 20;          % Maximum combined allocation for X and Y
int: min_weighted_demand = 10;          % Minimum required: X + 2*Y
int: max_balance_difference = 15;       % Maximum allowed: 2*X - Y

int: cost_per_unit_x = 5;               % Cost per unit allocated to service X
int: cost_per_unit_y = 4;               % Cost per unit allocated to service Y

% Variables
var 0..max_total_resources: x;          % Integer allocation to service X (non-negative)
var 0..max_total_resources: y;          % Integer allocation to service Y (non-negative)

% Upper bound is a safe (loose) bound: allocating max_total_resources to both
var 0..(cost_per_unit_x*max_total_resources + cost_per_unit_y*max_total_resources): total_cost;

% Constraints
% Link total_cost to the allocations and unit costs
constraint total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Total resource capacity constraint (X + Y cannot exceed maximum available)
constraint x + y <= max_total_resources;

% Minimum demand constraint (X + 2*Y must be at least the required minimum)
constraint x + 2 * y >= min_weighted_demand;

% Operational balance constraint (2*X - Y must not exceed the allowed maximum)
constraint 2 * x - y <= max_balance_difference;

% Objective
solve minimize total_cost;