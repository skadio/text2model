% Parameters
int: min_budget_X = 200;
int: min_budget_Y = 100;
int: max_total_budget = 1000;
int: unit_cost_X = 50;
int: unit_cost_Y = 80;

% Variables
var min_budget_X..max_total_budget: budget_X;
var min_budget_Y..max_total_budget: budget_Y;

% Constraints
constraint budget_X + budget_Y <= max_total_budget;

% Objective
solve minimize unit_cost_X * budget_X + unit_cost_Y * budget_Y;