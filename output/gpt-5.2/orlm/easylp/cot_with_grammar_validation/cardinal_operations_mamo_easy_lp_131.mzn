% Parameters
int: budget_limit = 10000;
int: impact_min = 40000;

int: impact_x_coeff = 10;
int: impact_y_coeff = 4;

int: cost_x = 50;
int: cost_y = 30;

% Variables
var 0..budget_limit: x; % budget for project X (integer dollars)
var 0..budget_limit: y; % budget for project Y (integer dollars)

var 0..(cost_x*budget_limit + cost_y*budget_limit): total_cost;

% Constraints
constraint x + y <= budget_limit;

constraint impact_x_coeff * x + impact_y_coeff * y >= impact_min;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;