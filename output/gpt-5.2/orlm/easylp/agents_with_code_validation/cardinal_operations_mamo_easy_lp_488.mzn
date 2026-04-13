% Parameters
int: max_total_resources = 10000;          % Maximum combined resources for divisions X and Y
int: min_weighted_resources = 6000;        % Minimum required value of (2*X + Y)
int: max_allocation_difference = 2000;     % Maximum allowed absolute difference |X - Y|
int: cost_per_unit_X = 5000;              % Cost per unit allocated to division X (dollars)
int: cost_per_unit_Y = 3000;              % Cost per unit allocated to division Y (dollars)

% Variables
var 0..max_total_resources: x;            % Whole units of resources allocated to division X
var 0..max_total_resources: y;            % Whole units of resources allocated to division Y
var 0..(cost_per_unit_X*max_total_resources + cost_per_unit_Y*max_total_resources): total_cost;
                                          % Total cost in dollars

% Constraints
% Total resources cap: combined allocation cannot exceed available resources
constraint x + y <= max_total_resources;

% Strategic minimum requirement: weighted sum of allocations must meet target
constraint 2 * x + y >= min_weighted_resources;

% Balance constraint: allocations between divisions must be within allowed difference
constraint abs(x - y) <= max_allocation_difference;

% Total cost definition: compute cost from allocations and per-unit costs
constraint total_cost = cost_per_unit_X * x + cost_per_unit_Y * y;

% Objective
solve minimize total_cost;