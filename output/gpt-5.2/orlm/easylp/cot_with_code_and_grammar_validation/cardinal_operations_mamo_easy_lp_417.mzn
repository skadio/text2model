% Parameters
int: total_budget = 5000;
int: req_effectiveness = 2000;
int: max_budget_diff = 1000;

int: cost_x = 1000;
int: cost_y = 1500;

% Variables
var 0..total_budget: x;
var 0..total_budget: y;
var 0..(cost_x*total_budget + cost_y*total_budget): total_cost;

% Constraints
constraint x + y <= total_budget;
constraint 3*x - 2*y >= req_effectiveness;
constraint x - y <= max_budget_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;