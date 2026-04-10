% Parameters
int: min_budget_X = 10;          % Minimum budget for Project X
int: min_budget_Y = 5;           % Minimum budget for Project Y
int: max_total_budget = 40;      % Maximum combined budget

int: outcome_per_unit_X = 50;    % Outcome per budget unit for X
int: outcome_per_unit_Y = 30;    % Outcome per budget unit for Y

% Variables
var min_budget_X..max_total_budget: budget_X;  % Integer budget allocated to Project X
var min_budget_Y..max_total_budget: budget_Y;  % Integer budget allocated to Project Y

% Total outcome upper bound based on maximum possible spending in either project
var 0..(outcome_per_unit_X * max_total_budget + outcome_per_unit_Y * max_total_budget): total_outcome;

% Constraints
% Budget feasibility: total allocated budget cannot exceed the maximum available
constraint
  budget_X + budget_Y <= max_total_budget;

% Link total outcome to allocated budgets (linear outcome calculation)
constraint
  total_outcome = outcome_per_unit_X * budget_X + outcome_per_unit_Y * budget_Y;

% Objective
solve maximize total_outcome;