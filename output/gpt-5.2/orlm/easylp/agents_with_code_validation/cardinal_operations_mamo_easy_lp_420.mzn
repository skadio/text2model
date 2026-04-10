% Parameters
int: budget_limit = 500;                 % Maximum allowed value for 5*X + 3*Y
int: min_total_investment = 60;          % Minimum required value for X + Y
int: diff_limit = 30;                    % Maximum allowed value for X - 2*Y
int: coef_budget_X = 5;                  % Coefficient of X in budget constraint
int: coef_budget_Y = 3;                  % Coefficient of Y in budget constraint
int: coef_diff_X = 1;                    % Coefficient of X in difference constraint
int: coef_diff_Y = 2;                    % Coefficient of Y in difference constraint (X - 2*Y)
int: cost_X = 50;                        % Cost per unit investment in project X
int: cost_Y = 70;                        % Cost per unit investment in project Y

% Upper bounds derived from constraints to keep variables bounded
int: X_ub = budget_limit div coef_budget_X;   % From 5*X <= 500 => X <= 100
int: Y_ub = budget_limit div coef_budget_Y;   % From 3*Y <= 500 => Y <= 166

% Variables
var 0..X_ub: invest_X;                        % Integer investment units in project X
var 0..Y_ub: invest_Y;                        % Integer investment units in project Y

% Total investment cost (objective), bounded using variable upper bounds
var 0..(cost_X * X_ub + cost_Y * Y_ub): total_cost;

% Constraints
% Budget constraint: 5*X + 3*Y cannot exceed the available budget
constraint
  coef_budget_X * invest_X + coef_budget_Y * invest_Y <= budget_limit;

% Minimum coverage constraint: total investment across both projects must be at least 60
constraint
  invest_X + invest_Y >= min_total_investment;

% Difference/limitation constraint: X - 2*Y must not exceed 30
constraint
  coef_diff_X * invest_X - coef_diff_Y * invest_Y <= diff_limit;

% Define total_cost consistently with chosen investments
constraint
  total_cost = cost_X * invest_X + cost_Y * invest_Y;

% Objective
solve minimize total_cost;