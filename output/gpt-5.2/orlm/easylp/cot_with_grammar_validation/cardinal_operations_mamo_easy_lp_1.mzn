% Parameters
int: max_budget = 2000;
int: cost_x = 50;
int: cost_y = 100;
int: min_diff = 500;

% Variables
var 0..max_budget: x;
var 0..max_budget: y;
var 0..(cost_x*max_budget + cost_y*max_budget): total_cost;

% Constraints
constraint x + y <= max_budget;
constraint 3 * x - 2 * y >= min_diff;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;