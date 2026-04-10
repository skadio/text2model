% Parameters
int: total_budget = 1000;                 % Total available resource units across all projects
int: min_alloc_X = 200;                   % Minimum allocation for project X
int: min_alloc_Y = 150;                   % Minimum allocation for project Y
int: min_alloc_Z = 100;                   % Minimum allocation for project Z
int: max_diff_X_over_Y = 50;              % X should not exceed Y by more than 50
int: min_diff_Y_over_Z = 20;              % Y should be at least 20 more than Z

int: cost_X = 300;                        % Cost per unit for X
int: cost_Y = 500;                        % Cost per unit for Y
int: cost_Z = 200;                        % Cost per unit for Z

% Variables
var 0..total_budget: alloc_X;             % Integer resource allocation to project X
var 0..total_budget: alloc_Y;             % Integer resource allocation to project Y
var 0..total_budget: alloc_Z;             % Integer resource allocation to project Z

% Upper bound: if all budget went to the most expensive project
int: max_unit_cost = max(cost_X, max(cost_Y, cost_Z));
var 0..(total_budget * max_unit_cost): total_cost; % Total cost (bounded)

% Constraints
% Minimum allocation (viability) constraints
constraint alloc_X >= min_alloc_X;
constraint alloc_Y >= min_alloc_Y;
constraint alloc_Z >= min_alloc_Z;

% Total budget constraint (sum of allocations cannot exceed total resources)
constraint alloc_X + alloc_Y + alloc_Z <= total_budget;

% Relative allocation constraints between projects
constraint alloc_X - alloc_Y <= max_diff_X_over_Y;  % X does not exceed Y by more than allowed
constraint alloc_Y - alloc_Z >= min_diff_Y_over_Z;  % Y is at least the required amount above Z

% Total cost definition constraint
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;

output [
  "alloc_X=", show(alloc_X), "\n",
  "alloc_Y=", show(alloc_Y), "\n",
  "alloc_Z=", show(alloc_Z), "\n",
  "total_cost=", show(total_cost), "\n"
];