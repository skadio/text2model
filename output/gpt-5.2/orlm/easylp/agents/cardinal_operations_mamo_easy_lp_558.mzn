% Parameters
% Total available allocation (budget in allocation units)
int: total_allocation_limit = 500;

% Minimum required allocation per project (in allocation units)
int: min_x = 100;
int: min_y = 50;
int: min_z = 20;

% Maximum allowed allocation per project (in allocation units)
int: max_x = 300;
int: max_y = 200;
int: max_z = 100;

% Cost per allocation unit for each project
int: cost_x = 40;
int: cost_y = 60;
int: cost_z = 100;


% Variables
% Allocation to each project (must be whole numbers)
var min_x..max_x: alloc_x;
var min_y..max_y: alloc_y;
var min_z..max_z: alloc_z;

% Total cost to minimize (upper bound based on maximum allocations)
var 0..(max_x*cost_x + max_y*cost_y + max_z*cost_z): total_cost;


% Constraints
% Budget/total allocation limit across all projects
constraint
  alloc_x + alloc_y + alloc_z <= total_allocation_limit;

% Define total cost from per-unit costs and allocations
constraint
  total_cost = cost_x * alloc_x + cost_y * alloc_y + cost_z * alloc_z;


% Objective
solve minimize total_cost;