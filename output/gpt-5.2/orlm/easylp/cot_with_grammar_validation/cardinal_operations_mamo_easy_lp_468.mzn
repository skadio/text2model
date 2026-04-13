% Parameters
int: budget_max = 100;
int: x_min = 30;
int: y_min = 20;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var x_min..budget_max: x;
var y_min..budget_max: y;
var 0..(budget_max * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x + y <= budget_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;