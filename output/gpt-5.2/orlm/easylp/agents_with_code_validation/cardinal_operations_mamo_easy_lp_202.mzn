% Parameters
% Total available budget across all projects
int: budget_limit = 5000;

% Minimum gap constraints
int: min_gap_X_vs_2Y = 1000;   % X - 2*Y >= 1000
int: min_gap_Z_vs_Y  = 1500;   % Z - Y  >= 1500

% Per-dollar cost coefficients
int: cost_X = 10;
int: cost_Y = 15;
int: cost_Z = 20;


% Variables
% Dollar allocations (whole dollars, non-negative, bounded by budget)
var 0..budget_limit: X;  % allocation to project X
var 0..budget_limit: Y;  % allocation to project Y
var 0..budget_limit: Z;  % allocation to project Z

% Total cost (bounded using max per-dollar cost * budget_limit)
var 0..(max([cost_X, cost_Y, cost_Z]) * budget_limit): total_cost;


% Constraints

% --- Budget feasibility ---
% Total allocated dollars across all projects cannot exceed the available budget.
constraint
  X + Y + Z <= budget_limit;

% --- Minimum gap requirements ---
% Project X must exceed twice project Y by at least the specified minimum gap.
constraint
  X - 2 * Y >= min_gap_X_vs_2Y;

% Project Z must exceed project Y by at least the specified minimum gap.
constraint
  Z - Y >= min_gap_Z_vs_Y;

% --- Total cost definition ---
% Total cost is the linear combination of allocations with their per-dollar costs.
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;


% Objective
solve minimize total_cost;