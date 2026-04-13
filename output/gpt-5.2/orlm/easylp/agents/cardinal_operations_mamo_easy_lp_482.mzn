% Parameters
int: min_budget_x = 10;          % Minimum budget for project X
int: min_budget_y = 5;           % Minimum budget for project Y
int: max_total_budget = 40;      % Maximum total budget for X + Y
int: outcome_per_unit_x = 50;    % Outcome per unit budget allocated to X
int: outcome_per_unit_y = 30;    % Outcome per unit budget allocated to Y

% Variables
var min_budget_x..max_total_budget: budget_x;  % Integer budget allocated to project X
var min_budget_y..max_total_budget: budget_y;  % Integer budget allocated to project Y
var 0..(outcome_per_unit_x * max_total_budget + outcome_per_unit_y * max_total_budget): total_outcome;
% Total outcome (bounded using max_total_budget)

% Constraints
% Budget feasibility: total allocation cannot exceed the available budget
constraint
  budget_x + budget_y <= max_total_budget;

% Outcome definition: compute total outcome from per-unit outcomes and allocated budgets
constraint
  total_outcome = outcome_per_unit_x * budget_x + outcome_per_unit_y * budget_y;

% Objective
solve maximize total_outcome;