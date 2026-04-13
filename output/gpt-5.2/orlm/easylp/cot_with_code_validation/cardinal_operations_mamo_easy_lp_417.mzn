% Parameters
int: budget_limit = 5000;
int: eff_rhs = 2000;
int: diff_limit = 1000;

int: cost_x = 1000;
int: cost_y = 1500;

% Variables
var 0..budget_limit: x;
var 0..budget_limit: y;

var 0..(budget_limit * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x + y <= budget_limit;

constraint 3*x - 2*y >= eff_rhs;

constraint x - y <= diff_limit;
constraint y - x <= diff_limit;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;