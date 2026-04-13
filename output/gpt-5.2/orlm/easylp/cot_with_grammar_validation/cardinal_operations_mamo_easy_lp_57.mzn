% Parameters
int: max_budget = 2000;
int: min_x_offset = 500;

int: cost_x = 2;
int: cost_y = 3;

int: x_lb = 0;
int: x_ub = 1500;
int: y_lb = 0;
int: y_ub = 1000;

% Variables
var x_lb..x_ub: x;
var y_lb..y_ub: y;

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
constraint x + y <= max_budget;
constraint x >= (y div 2) + min_x_offset;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;