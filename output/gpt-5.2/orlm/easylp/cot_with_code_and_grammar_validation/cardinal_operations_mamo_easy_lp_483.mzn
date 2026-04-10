% Parameters
int: max_budget = 100;
int: min_total_alloc = 20;
int: max_diff = 30;

int: budget_x_coef = 4;
int: budget_y_coef = 5;

int: cost_x = 6;
int: cost_y = 2;

% Variables
var 0..max_budget: x;
var 0..max_budget: y;

var 0..(cost_x * max_budget + cost_y * max_budget): total_cost;

% Constraints
constraint budget_x_coef * x + budget_y_coef * y <= max_budget;
constraint x + y >= min_total_alloc;

constraint abs(2 * x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;