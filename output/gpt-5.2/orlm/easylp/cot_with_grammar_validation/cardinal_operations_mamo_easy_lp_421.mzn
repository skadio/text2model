% Parameters
int: total_max = 5000;
int: min_x = 1000;
int: min_y = 1500;
int: cost_x = 100;
int: cost_y = 75;

% Variables
var min_x..total_max: x;
var min_y..total_max: y;
var 0..(cost_x*total_max + cost_y*total_max): total_cost;

% Constraints
constraint x + y <= total_max;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;