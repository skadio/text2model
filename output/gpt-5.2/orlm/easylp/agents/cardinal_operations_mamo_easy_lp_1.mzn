% Parameters
int: max_total_budget = 2000;         % Maximum combined budget for channels X and Y
int: cost_per_unit_x = 50;            % Cost per unit for channel X
int: cost_per_unit_y = 100;           % Cost per unit for channel Y
int: min_effort_diff = 500;           % Minimum required difference: 3*X - 2*Y >= 500

% Variables
var 0..max_total_budget: budget_x;    % Integer budget allocated to channel X
var 0..max_total_budget: budget_y;    % Integer budget allocated to channel Y

% Constraints
% Budget feasibility: total allocation cannot exceed the maximum allowed
constraint budget_x + budget_y <= max_total_budget;

% Campaign reach/frequency requirement:
% "effort from X should be three times greater than twice Y" interpreted as 3*X - 2*Y >= 500
constraint 3 * budget_x - 2 * budget_y >= min_effort_diff;

% Objective
solve minimize cost_per_unit_x * budget_x + cost_per_unit_y * budget_y;