% Parameters
int: total_allocation_limit = 500;          % Maximum total allocation across all projects

int: min_alloc_X = 100;                     % Minimum allocation for project X
int: min_alloc_Y = 50;                      % Minimum allocation for project Y
int: min_alloc_Z = 20;                      % Minimum allocation for project Z

int: max_alloc_X = 300;                     % Maximum allocation for project X
int: max_alloc_Y = 200;                     % Maximum allocation for project Y
int: max_alloc_Z = 100;                     % Maximum allocation for project Z

int: cost_X = 40;                           % Cost per unit allocation for project X
int: cost_Y = 60;                           % Cost per unit allocation for project Y
int: cost_Z = 100;                          % Cost per unit allocation for project Z

% Variables
var min_alloc_X..max_alloc_X: alloc_X;      % Integer allocation to project X
var min_alloc_Y..max_alloc_Y: alloc_Y;      % Integer allocation to project Y
var min_alloc_Z..max_alloc_Z: alloc_Z;      % Integer allocation to project Z

var 0..(cost_X*max_alloc_X + cost_Y*max_alloc_Y + cost_Z*max_alloc_Z): total_cost;
                                            % Total cost (bounded upper by max allocations)

% Constraints
% Allocation feasibility: total allocation cannot exceed the overall budget limit
constraint
  alloc_X + alloc_Y + alloc_Z <= total_allocation_limit;

% Cost definition: link total_cost to per-project allocations and unit costs
constraint
  total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;