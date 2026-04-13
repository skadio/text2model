% Parameters
% Total budget limit (in dollars)
int: max_total_budget = 5000;

% Cost per unit of budget invested in each department (in dollars per unit)
int: cost_X = 10;
int: cost_Y = 20;
int: cost_Z = 30;

% Effectiveness requirement threshold
int: min_effectiveness = 10000;

% Maximum allowed difference in budget between X and Z (in dollars)
int: max_budget_diff_XZ = 1500;

% Effectiveness coefficients (sales revenue per unit)
int: eff_coeff_X = 5;
int: eff_coeff_Y = 10;

% Variables
% Budget allocated to each department (whole dollars, non-negative)
var 0..max_total_budget: budget_X;
var 0..max_total_budget: budget_Y;
var 0..max_total_budget: budget_Z;

% Total cost to be minimized (bounded for safe linear arithmetic)
var 0..(cost_X + cost_Y + cost_Z) * max_total_budget: total_cost;

% Constraints
% Total allocated budget across departments cannot exceed the maximum available
constraint budget_X + budget_Y + budget_Z <= max_total_budget;

% Combined effectiveness from X and Y must meet the minimum target
constraint eff_coeff_X * budget_X + eff_coeff_Y * budget_Y >= min_effectiveness;

% The absolute difference in allocated budgets between X and Z is limited
constraint abs(budget_X - budget_Z) <= max_budget_diff_XZ;

% Total cost induced by budget allocations and per-unit costs
constraint total_cost = cost_X * budget_X + cost_Y * budget_Y + cost_Z * budget_Z;

% Objective
solve minimize total_cost;