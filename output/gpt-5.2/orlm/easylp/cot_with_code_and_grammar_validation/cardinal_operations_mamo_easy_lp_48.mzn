% Parameters
int: min_service = 10;
int: budget_cap = 30;
int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..budget_cap: x;
var 0..budget_cap: y;
var 0..(cost_x*budget_cap + cost_y*budget_cap): total_cost;

% Constraints
constraint x + 3*y >= min_service;
constraint 2*x + y <= budget_cap;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;