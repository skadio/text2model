% Parameters
% All data embedded directly as per instructions (no .dzn expected)

int: budget_limit = 500;          % Maximum allowed for 5*X + 3*Y
int: min_total_invest = 60;       % Minimum required X + Y
int: diff_limit = 30;             % Maximum allowed for X - 2*Y

int: coeff_budget_x = 5;          % Coefficient of X in budget constraint
int: coeff_budget_y = 3;          % Coefficient of Y in budget constraint

int: cost_x = 50;                 % Cost per unit of investment in Project X
int: cost_y = 70;                 % Cost per unit of investment in Project Y

% Variable upper bounds derived from constraints for tighter domains
int: max_x = budget_limit div coeff_budget_x;   % from 5*X <= 500 -> X <= 100
int: max_y = budget_limit div coeff_budget_y;   % from 3*Y <= 500 -> Y <= 166

% Variables
var 0..max_x: invest_x;           % Whole-number investment in Project X
var 0..max_y: invest_y;           % Whole-number investment in Project Y

var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total investment cost (objective)

% Constraints

% Budget/resource constraint: 5*X + 3*Y cannot exceed the budget limit
constraint
  coeff_budget_x * invest_x + coeff_budget_y * invest_y <= budget_limit;

% Minimum coverage constraint: total investment must be at least the required minimum
constraint
  invest_x + invest_y >= min_total_invest;

% Difference/limitation constraint: X - 2*Y must not exceed the specified limit
constraint
  invest_x - 2 * invest_y <= diff_limit;

% Define total cost variable consistently with per-unit costs
constraint
  total_cost = cost_x * invest_x + cost_y * invest_y;

% Objective
solve minimize total_cost;