% Parameters
int: cost_X = 10;                   % Cost per unit for project X
int: cost_Y = 20;                   % Cost per unit for project Y
int: cost_Z = 30;                   % Cost per unit for project Z

int: max_total_allocation = 10000;  % Upper bound on X+Y+Z
int: min_weighted_requirement = 5000; % Lower bound on 2X+3Y+Z
int: max_balance_limit = 3000;      % Upper bound on (X - Y + Z)

% Variables
var 0..max_total_allocation: alloc_X; % Whole-number allocation to project X
var 0..max_total_allocation: alloc_Y; % Whole-number allocation to project Y
var 0..max_total_allocation: alloc_Z; % Whole-number allocation to project Z

% Upper bound on total cost if all allocation went to each project (safe, though loose)
var 0..(cost_X*max_total_allocation + cost_Y*max_total_allocation + cost_Z*max_total_allocation): total_cost;

% Constraints
% Link total_cost to the linear cost expression
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Total allocation must not exceed the overall budget limit
constraint alloc_X + alloc_Y + alloc_Z <= max_total_allocation;

% Meet the minimum weighted requirement: 2X + 3Y + Z >= threshold
constraint 2 * alloc_X + 3 * alloc_Y + alloc_Z >= min_weighted_requirement;

% Balanced distribution constraint: (X - Y + Z) must not exceed limit
constraint alloc_X - alloc_Y + alloc_Z <= max_balance_limit;

% Objective
solve minimize total_cost;