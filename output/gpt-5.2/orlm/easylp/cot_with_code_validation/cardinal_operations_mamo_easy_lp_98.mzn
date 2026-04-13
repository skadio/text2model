% Parameters
int: total_budget = 50000;
int: min_diff = 10000;

int: cost_x = 5000;
int: cost_y = 7000;

int: max_x = 40;
int: max_y = 20;

% Variables
var 0..max_x: x;
var 0..max_y: y;

var 0..total_budget: total_cost;

% Constraints
constraint total_cost = cost_x * x + cost_y * y;

constraint total_cost <= total_budget;

constraint 3 * (cost_x * x) - (cost_y * y) >= min_diff;

% Objective
solve minimize total_cost;