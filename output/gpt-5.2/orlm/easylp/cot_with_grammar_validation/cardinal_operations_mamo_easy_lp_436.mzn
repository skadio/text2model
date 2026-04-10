% Parameters
int: min_budget_X = 200;
int: min_budget_Y = 100;
int: max_total_budget = 1000;
int: unit_cost_X = 50;
int: unit_cost_Y = 80;

% Variables
var int: x_units;
var int: y_units;
var int: budget_X;
var int: budget_Y;
var int: total_budget;
var int: total_cost;

% Constraints
constraint x_units >= 0;
constraint y_units >= 0;

constraint budget_X = unit_cost_X * x_units;
constraint budget_Y = unit_cost_Y * y_units;

constraint budget_X >= min_budget_X;
constraint budget_Y >= min_budget_Y;

constraint total_budget = budget_X + budget_Y;
constraint total_budget <= max_total_budget;

constraint total_cost = budget_X + budget_Y;

% Objective
solve minimize total_cost;