% Parameters (with values embedded)
int: min_total_investment = 30;
int: max_resource_usage = 150;
int: resource_coef_x = 5;
int: resource_coef_y = 3;
int: cost_x = 40;
int: cost_y = 50;

% Variables
% Upper bounds derived from max_resource_usage (since x,y are nonnegative integers)
var 0..(max_resource_usage div resource_coef_x): x;
var 0..(max_resource_usage div resource_coef_y): y;

% Constraints
constraint x + y >= min_total_investment;
constraint resource_coef_x * x + resource_coef_y * y <= max_resource_usage;

% Objective
var int: total_cost = cost_x * x + cost_y * y;
solve minimize total_cost;