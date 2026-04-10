% Parameters
int: budget_limit = 10;
int: strategic_min = 6;

int: coef_budget_X = 4;
int: coef_budget_Y = 1;

int: coef_strat_X = 1;
int: coef_strat_Y = 2;

int: cost_X = 7;
int: cost_Y = 3;

% Variables
var 0..budget_limit: x;
var 0..budget_limit: y;
var 0..(cost_X * budget_limit + cost_Y * budget_limit): total_cost;

% Constraints
constraint coef_budget_X * x + coef_budget_Y * y <= budget_limit;
constraint coef_strat_X * x + coef_strat_Y * y >= strategic_min;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;