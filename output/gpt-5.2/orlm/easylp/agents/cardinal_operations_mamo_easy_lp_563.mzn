% Parameters
int: total_budget = 1000;          % Total budget to allocate across X, Y, Z
int: min_diff_XY = 200;            % X must be at least this much more than Y
int: max_budget_Z = 300;           % Upper bound on Z allocation

int: cost_X = 50;                  % Cost per unit allocated to X
int: cost_Y = 30;                  % Cost per unit allocated to Y
int: cost_Z = 20;                  % Cost per unit allocated to Z

% Variables
var 0..total_budget: x;            % Budget allocated to department X (integer units)
var 0..total_budget: y;            % Budget allocated to department Y (integer units)
var 0..max_budget_Z: z;            % Budget allocated to department Z (integer units)
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost; % Total cost (bounded)

% Constraints
% Budget conservation: total allocation must match the fixed total budget
constraint
  x + y + z = total_budget;

% Minimum difference requirement: X must be at least min_diff_XY more than Y
constraint
  x >= y + min_diff_XY;

% Maximum allowable budget for Z (redundant with z's domain but kept for clarity)
constraint
  z <= max_budget_Z;

% Total cost computation from per-unit costs
constraint
  total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;