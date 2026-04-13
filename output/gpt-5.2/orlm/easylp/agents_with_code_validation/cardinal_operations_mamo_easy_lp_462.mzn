% Parameters
int: max_total_resources = 1000;              % Maximum combined allocation to warehouses X and Y
int: min_capacity_requirement = 2500;         % Minimum required capacity: 3*X + 2*Y
int: max_allocation_difference = 300;         % Maximum allowed absolute difference |X - Y|
int: cost_per_unit_X = 7;                     % Cost per unit allocated to warehouse X
int: cost_per_unit_Y = 5;                     % Cost per unit allocated to warehouse Y

% Explicit variable bounds (non-negative whole-number allocations)
int: min_alloc_X = 0;
int: max_alloc_X = max_total_resources;       % Cannot exceed total resources
int: min_alloc_Y = 0;
int: max_alloc_Y = max_total_resources;       % Cannot exceed total resources

% Variables
var min_alloc_X..max_alloc_X: alloc_X;        % Units allocated to warehouse X (integer)
var min_alloc_Y..max_alloc_Y: alloc_Y;        % Units allocated to warehouse Y (integer)
var 0..(cost_per_unit_X*max_alloc_X + cost_per_unit_Y*max_alloc_Y): total_cost; % Total cost in dollars

% Constraints

% Total allocation limit
constraint
  alloc_X + alloc_Y <= max_total_resources;

% Minimum capacity requirement: 3*X + 2*Y meets demand
constraint
  3 * alloc_X + 2 * alloc_Y >= min_capacity_requirement;

% Operational balance constraint: limits |X - Y|
constraint
  abs(alloc_X - alloc_Y) <= max_allocation_difference;

% Total cost definition
constraint
  total_cost = cost_per_unit_X * alloc_X + cost_per_unit_Y * alloc_Y;

% Objective
solve minimize total_cost;