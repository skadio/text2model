% Parameters
int: total_budget = 100;
int: min_x = 30;
int: min_y = 20;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var min_x..total_budget: x;
var min_y..total_budget: y;
var 0..(cost_x * total_budget + cost_y * total_budget): total_cost;

% Constraints
constraint x + y <= total_budget;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;