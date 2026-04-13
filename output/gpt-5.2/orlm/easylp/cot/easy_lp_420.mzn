% Parameters (with values embedded)
int: budget_limit = 500;
int: min_total_investment = 60;
int: diff_limit = 30;

int: coef_budget_x = 5;
int: coef_budget_y = 3;

int: return_x = 50;
int: return_y = 70;

% Variables
var 0..budget_limit: x;  % investment in Project X (integer, non-negative)
var 0..budget_limit: y;  % investment in Project Y (integer, non-negative)

% Constraints
constraint coef_budget_x * x + coef_budget_y * y <= budget_limit;
constraint x + y >= min_total_investment;
constraint x - 2 * y <= diff_limit;

% Objective
solve minimize return_x * x + return_y * y;