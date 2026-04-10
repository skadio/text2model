% Parameters
int: max_total_budget = 5000;              % Maximum combined budget for channels X and Y (in $)
int: min_diff_2x_minus_y = 1000;           % Minimum value for (2*X - Y) (in $)
int: max_diff_x_minus_3y = 2000;           % Maximum value for (X - 3*Y) (in $)
int: cost_per_unit_x = 1000;               % Cost per unit effectiveness for channel X (in $)
int: cost_per_unit_y = 1500;               % Cost per unit effectiveness for channel Y (in $)

% Variables
var 0..max_total_budget: budget_x;         % Integer budget allocated to channel X (in $)
var 0..max_total_budget: budget_y;         % Integer budget allocated to channel Y (in $)
var 0..(cost_per_unit_x*max_total_budget + cost_per_unit_y*max_total_budget): total_cost;
                                           % Total expenditure to minimize (in $)

% Constraints
% Budget limit: combined allocation cannot exceed the maximum total budget
constraint
  budget_x + budget_y <= max_total_budget;

% Minimum difference constraint: (2*X - Y) must be at least the specified minimum
constraint
  2 * budget_x - budget_y >= min_diff_2x_minus_y;

% Maximum difference constraint: (X - 3*Y) must not exceed the specified maximum
constraint
  budget_x - 3 * budget_y <= max_diff_x_minus_3y;

% Total cost definition: link total_cost to budgets and per-unit costs
constraint
  total_cost = cost_per_unit_x * budget_x + cost_per_unit_y * budget_y;

% Objective
solve minimize total_cost;

output [
  "budget_x = ", show(budget_x), "\n",
  "budget_y = ", show(budget_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];