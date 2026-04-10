% Parameters
int: total_budget = 200;
int: min_x = 50;
int: min_y = 30;
int: cost_x = 5000;
int: cost_y = 8000;

% Variables
var min_x..total_budget: x;
var min_y..total_budget: y;
var 0..(total_budget * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x + y <= total_budget;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;