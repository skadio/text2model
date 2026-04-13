% Parameters
% Total budget limit
int: max_budget = 1000;

% Allocation relationship requirements
int: x_min_over_2y = 200;   % X >= 2*Y + 200
int: z_min_over_y  = 150;   % Z >= Y + 150

% Cost coefficients (cost per $ allocated) for each department
int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 20;

% Allocation bounds (nonnegative whole-dollar allocations; explicit upper bound via max_budget)
int: min_alloc = 0;
int: max_alloc = max_budget;

% Variables
var min_alloc..max_alloc: alloc_X; % Funds allocated to department X (General Medicine)
var min_alloc..max_alloc: alloc_Y; % Funds allocated to department Y (Pediatrics)
var min_alloc..max_alloc: alloc_Z; % Funds allocated to department Z (Surgery)

% Total cost to minimize (safe upper bound based on max_budget for each department)
var 0..(cost_X*max_budget + cost_Y*max_budget + cost_Z*max_budget): total_cost;

% Constraints
% --- Budget feasibility constraints ---
% Total allocations across all departments cannot exceed the available budget
constraint alloc_X + alloc_Y + alloc_Z <= max_budget;

% --- Inter-department allocation relationship constraints ---
% Department X must be at least $200 more than twice Department Y
constraint alloc_X >= 2 * alloc_Y + x_min_over_2y;

% Department Z must exceed Department Y by at least $150
constraint alloc_Z >= alloc_Y + z_min_over_y;

% --- Cost accounting constraint ---
% Total cost computed from allocations and per-dollar cost coefficients
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;