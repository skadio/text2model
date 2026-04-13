% Parameters
int: min_service = 10;          % Minimum service requirement: x + 3*y >= 10
int: budget_limit = 30;         % Budget constraint: 2*x + y <= 30
int: cost_x = 4;                % Cost per unit allocated to department X
int: cost_y = 5;                % Cost per unit allocated to department Y

% Variables
var 0..budget_limit: x;         % Whole units allocated to department X (non-negative, bounded)
var 0..budget_limit: y;         % Whole units allocated to department Y (non-negative, bounded)
var 0..(cost_x*budget_limit + cost_y*budget_limit): total_cost; % Total cost (bounded)

% Constraints
% Link total cost to allocations
constraint total_cost = cost_x * x + cost_y * y;

% Minimum essential services requirement
constraint x + 3 * y >= min_service;

% Budgetary/resource limit constraint
constraint 2 * x + y <= budget_limit;

% Objective
solve minimize total_cost;