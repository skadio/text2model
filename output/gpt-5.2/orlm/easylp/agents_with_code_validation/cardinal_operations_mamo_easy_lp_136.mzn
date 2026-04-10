% Parameters
% Budget limits
int: max_total_allocation = 200;   % alloc_X + alloc_Y <= 200
int: min_total_allocation = 50;    % alloc_X + alloc_Y >= 50

% Unit costs
int: cost_X = 5;                   % cost per unit allocated to X
int: cost_Y = 8;                   % cost per unit allocated to Y


% Variables
% Whole-number allocations to projects X and Y
var 0..max_total_allocation: alloc_X;
var 0..max_total_allocation: alloc_Y;

% Total cost (upper bound based on maximum allocation and maximum unit cost)
var 0..(max_total_allocation * max(cost_X, cost_Y)): total_cost;


% Constraints
% Total allocation must respect the overall budget ceiling
constraint alloc_X + alloc_Y <= max_total_allocation;

% Total allocation must meet the minimum required funding level
constraint alloc_X + alloc_Y >= min_total_allocation;

% Define total cost as the weighted sum of allocations by per-unit costs
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y;


% Objective
solve minimize total_cost;