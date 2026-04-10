% Parameters
int: max_budget = 1000;              % Maximum total budget available
int: min_x = 200;                    % Minimum allocation for Campaign X
int: min_y = 100;                    % Minimum allocation for Campaign Y
int: min_z = 50;                     % Minimum allocation for Campaign Z
int: cost_x = 2;                     % Cost per unit allocated to Campaign X
int: cost_y = 3;                     % Cost per unit allocated to Campaign Y
int: cost_z = 4;                     % Cost per unit allocated to Campaign Z

% Variables
var min_x..max_budget: alloc_x;      % Integer allocation to Campaign X
var min_y..max_budget: alloc_y;      % Integer allocation to Campaign Y
var min_z..max_budget: alloc_z;      % Integer allocation to Campaign Z

var 0..(cost_x*max_budget + cost_y*max_budget + cost_z*max_budget): total_cost;
                                     % Total cost (bounded for linear expressions)

% Constraints
%--- Budget feasibility: total allocation cannot exceed available budget
constraint
  alloc_x + alloc_y + alloc_z <= max_budget;

%--- Total cost definition: compute cost from allocations and per-unit costs
constraint
  total_cost = cost_x * alloc_x + cost_y * alloc_y + cost_z * alloc_z;

% Objective
solve minimize total_cost;

% Optional output for clarity
output [
  "alloc_x=", show(alloc_x), "\n",
  "alloc_y=", show(alloc_y), "\n",
  "alloc_z=", show(alloc_z), "\n",
  "total_cost=", show(total_cost), "\n"
];