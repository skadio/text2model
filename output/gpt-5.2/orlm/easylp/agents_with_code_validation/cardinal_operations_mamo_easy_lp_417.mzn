% Parameters
int: max_total_budget = 5000;              % Total budget limit for channels X and Y
int: min_effectiveness = 2000;             % Minimum required effectiveness points
int: max_budget_difference = 1000;         % Maximum allowed difference between budgets

int: eff_coeff_x = 3;                      % Effectiveness coefficient for channel X
int: eff_coeff_y = -2;                     % Effectiveness coefficient for channel Y (subtracted)

int: cost_per_unit_x = 1000;               % Cost per unit for channel X (dollars)
int: cost_per_unit_y = 1500;               % Cost per unit for channel Y (dollars)

% Variables
var 0..max_total_budget: budget_x;         % Whole-number budget allocated to channel X
var 0..max_total_budget: budget_y;         % Whole-number budget allocated to channel Y

var 0..(cost_per_unit_x*max_total_budget + cost_per_unit_y*max_total_budget): total_cost;
                                           % Total cost in dollars (bounded)

% Constraints
% Total budget limit across both channels
constraint budget_x + budget_y <= max_total_budget;

% Minimum effectiveness requirement: eff_coeff_x*X + eff_coeff_y*Y >= min_effectiveness
constraint eff_coeff_x * budget_x + eff_coeff_y * budget_y >= min_effectiveness;

% Maximum allowed absolute difference between channel budgets
constraint abs(budget_x - budget_y) <= max_budget_difference;

% Define total cost based on per-unit costs
constraint total_cost = cost_per_unit_x * budget_x + cost_per_unit_y * budget_y;

% Objective
solve minimize total_cost;