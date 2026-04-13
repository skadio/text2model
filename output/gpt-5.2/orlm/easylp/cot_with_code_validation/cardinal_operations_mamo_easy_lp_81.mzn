% Parameters
int: req_min = 200;
int: cap_max = 300;
int: x_max = 100;
int: y_max = 80;
int: cost_x = 500;
int: cost_y = 600;

% Variables
var 0..x_max: x;
var 0..y_max: y;
var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint 2 * x + 3 * y >= req_min;
constraint 4 * x + y <= cap_max;
constraint x >= y;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;