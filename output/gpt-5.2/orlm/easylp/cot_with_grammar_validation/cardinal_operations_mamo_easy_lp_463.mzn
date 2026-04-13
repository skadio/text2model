% Parameters
int: total_max = 5000;
int: x_min = 1000;
int: y_max = 3000;
int: cost_x = 50;
int: cost_y = 75;

% Variables
var 0..total_max: x;
var 0..total_max: y;
var 0..(cost_x*total_max + cost_y*total_max): total_cost;

% Constraints
constraint x >= x_min;
constraint y <= y_max;
constraint x + y <= total_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;