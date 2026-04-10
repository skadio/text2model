% Parameters
int: total_budget = 100;
int: min_effectiveness = 50;
int: max_diff = 30;
int: cost_x = 5;
int: cost_y = 8;

% Variables
var 0..total_budget: x;
var 0..total_budget: y;
var 0..(cost_x * total_budget + cost_y * total_budget): total_cost;

% Constraints
constraint x + y <= total_budget;
constraint 2 * x + y >= min_effectiveness;
constraint abs(x - y) <= max_diff;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;