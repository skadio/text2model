% Parameters
int: budget_max = 2000;
int: x_min = 0;
int: x_max = 1500;
int: y_min = 0;
int: y_max = 1000;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var x_min..x_max: x;
var y_min..y_max: y;
var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint x + y <= budget_max;
constraint x >= (y div 2) + 500;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;