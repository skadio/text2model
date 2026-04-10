% Parameters
% Maximum total budget allowed for both channels combined
int: max_total_budget = 5000;

% Minimum required effectiveness score: 3*X + 4*Y >= min_effectiveness
int: min_effectiveness = 12000;

% Upper bound on balance constraint: 5*X - 2*Y <= max_balance_score
int: max_balance_score = 10000;

% Effectiveness coefficients for channels X and Y
int: eff_coef_x = 3;
int: eff_coef_y = 4;

% Balance constraint coefficients for channels X and Y (5*X - 2*Y)
int: bal_coef_x = 5;
int: bal_coef_y = -2;

% Cost per dollar allocated to each channel
int: cost_x = 200;
int: cost_y = 150;

% Variables
% Budget allocated to channel X and Y (whole dollars, non-negative, capped by max_total_budget)
var 0..max_total_budget: budget_x;
var 0..max_total_budget: budget_y;

% Total cost to minimize
var 0..(max_total_budget * max(cost_x, cost_y)): total_cost;

% Constraints
% Total budget limit
constraint budget_x + budget_y <= max_total_budget;

% Minimum effectiveness requirement
constraint eff_coef_x * budget_x + eff_coef_y * budget_y >= min_effectiveness;

% Balance/design constraint
constraint bal_coef_x * budget_x + bal_coef_y * budget_y <= max_balance_score;

% Define total cost
constraint total_cost = cost_x * budget_x + cost_y * budget_y;

% Objective
solve minimize total_cost;