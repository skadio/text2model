% Parameters
int: total_budget = 1000;          % Total budget to allocate
int: min_diff_XY = 200;            % X must be at least this much more than Y
int: max_budget_Z = 300;           % Upper bound on Z allocation

int: cost_X = 50;                  % Cost per unit allocated to X
int: cost_Y = 30;                  % Cost per unit allocated to Y
int: cost_Z = 20;                  % Cost per unit allocated to Z

% Variables
var 0..total_budget: x;            % Units allocated to department X
var 0..total_budget: y;            % Units allocated to department Y
var 0..max_budget_Z: z;            % Units allocated to department Z (capped)

% Upper bound on total cost (safe over-approximation)
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*max_budget_Z): total_cost;

% Constraints
% Budget balance: allocations must sum exactly to the total budget
constraint x + y + z = total_budget;

% Minimum difference requirement: X must be at least min_diff_XY more than Y
constraint x - y >= min_diff_XY;

% Maximum allowable allocation for Z (also enforced by z's domain, repeated for clarity)
constraint z <= max_budget_Z;

% Total cost definition based on per-unit costs
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;