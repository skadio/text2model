% Parameters
int: budget_limit = 10;                  % Maximum allowed for 4*X + Y
int: target_min = 6;                     % Minimum required for X + 2*Y
int: coeff_budget_x = 4;                 % Coefficient of X in budget constraint
int: coeff_budget_y = 1;                 % Coefficient of Y in budget constraint
int: coeff_target_x = 1;                 % Coefficient of X in target constraint
int: coeff_target_y = 2;                 % Coefficient of Y in target constraint
int: cost_x = 7;                         % Cost per unit of X
int: cost_y = 3;                         % Cost per unit of Y

% Useful safe upper bounds derived from constraints (for bounded decision vars)
int: max_x = budget_limit div coeff_budget_x;   % From 4*X <= 10  => X <= 2
int: max_y = budget_limit div coeff_budget_y;   % From Y <= 10

% Variables
var 0..max_x: x;                                % Integer units invested in project X
var 0..max_y: y;                                % Integer units invested in project Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost; % Total cost to minimize

% Constraints
% Budget feasibility: 4*X + 1*Y must not exceed the budget limit
constraint
  coeff_budget_x * x + coeff_budget_y * y <= budget_limit;

% Strategic target: 1*X + 2*Y must meet or exceed the minimum target
constraint
  coeff_target_x * x + coeff_target_y * y >= target_min;

% Total cost definition: link total_cost to decision variables
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;