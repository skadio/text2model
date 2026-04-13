% Parameters
int: total_budget = 1000;              % Maximum total allocation across X, Y, Z
int: min_X = 200;                      % Minimum allocation required for department X
int: min_Y = 150;                      % Minimum allocation required for department Y
int: min_Z = 120;                      % Minimum allocation required for department Z
int: cost_X = 10;                      % Cost per unit allocated to department X
int: cost_Y = 20;                      % Cost per unit allocated to department Y
int: cost_Z = 30;                      % Cost per unit allocated to department Z

% Variables
var min_X..total_budget: alloc_X;      % Allocation to department X (integer units)
var min_Y..total_budget: alloc_Y;      % Allocation to department Y (integer units)
var min_Z..total_budget: alloc_Z;      % Allocation to department Z (integer units)

% Upper bound is the worst case if each department took total_budget units
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
% Budget feasibility: total allocation across all departments cannot exceed total budget
constraint alloc_X + alloc_Y + alloc_Z <= total_budget;

% Cost definition: total cost equals sum of per-unit costs times allocations
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;

output [
  "alloc_X = ", show(alloc_X), "\n",
  "alloc_Y = ", show(alloc_Y), "\n",
  "alloc_Z = ", show(alloc_Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];