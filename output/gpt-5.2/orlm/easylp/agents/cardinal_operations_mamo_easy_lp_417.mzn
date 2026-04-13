% Parameters
% Budget limit (dollars)
int: max_total_budget = 5000;

% Effectiveness requirement: 3*X - 2*Y >= min_effectiveness_points
int: min_effectiveness_points = 2000;

% Absolute difference constraint: |X - Y| <= max_budget_difference
int: max_budget_difference = 1000;

% Cost per unit (dollars)
int: cost_per_unit_x = 1000;
int: cost_per_unit_y = 1500;


% Variables
% Budget allocated to channel X (whole dollars)
var 0..max_total_budget: budget_x;

% Budget allocated to channel Y (whole dollars)
var 0..max_total_budget: budget_y;

% Total cost to minimize (dollars)
var 0..(cost_per_unit_x*max_total_budget + cost_per_unit_y*max_total_budget): total_cost;


% Constraints
% Budget limit across both channels
constraint budget_x + budget_y <= max_total_budget;

% Minimum effectiveness requirement: 3*X - 2*Y >= required points
constraint 3 * budget_x - 2 * budget_y >= min_effectiveness_points;

% Maximum allowed difference between channel budgets: |X - Y| <= limit
constraint abs(budget_x - budget_y) <= max_budget_difference;

% Define total cost from per-unit costs and allocated budgets
constraint total_cost = cost_per_unit_x * budget_x + cost_per_unit_y * budget_y;


% Objective
solve minimize total_cost;