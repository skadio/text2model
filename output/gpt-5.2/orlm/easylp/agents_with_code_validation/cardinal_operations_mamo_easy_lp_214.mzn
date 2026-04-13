% Parameters
int: total_allocation_limit = 1000;      % Maximum total units allocatable across X, Y, Z

int: min_alloc_X = 200;                  % Minimum units required for department X
int: min_alloc_Y = 150;                  % Minimum units required for department Y
int: min_alloc_Z = 100;                  % Minimum units required for department Z

int: cost_per_unit_X = 50;               % Cost per unit allocated to X
int: cost_per_unit_Y = 60;               % Cost per unit allocated to Y
int: cost_per_unit_Z = 70;               % Cost per unit allocated to Z


% Variables
var min_alloc_X..total_allocation_limit: alloc_X;  % Whole-number allocation to X
var min_alloc_Y..total_allocation_limit: alloc_Y;  % Whole-number allocation to Y
var min_alloc_Z..total_allocation_limit: alloc_Z;  % Whole-number allocation to Z

var int: total_cost;                               % Total cost (to minimize)


% Constraints
% Total allocation limit across all departments
constraint
  alloc_X + alloc_Y + alloc_Z <= total_allocation_limit;

% Total cost definition
constraint
  total_cost =
    cost_per_unit_X * alloc_X +
    cost_per_unit_Y * alloc_Y +
    cost_per_unit_Z * alloc_Z;


% Objective
solve minimize total_cost;