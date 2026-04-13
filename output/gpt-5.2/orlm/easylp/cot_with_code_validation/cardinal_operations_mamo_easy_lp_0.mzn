% Parameters
int: total_max = 1000;
int: min_excess = 200;

int: cost_x = 50;
int: cost_y = 30;

int: x_max = 700;
int: y_max = 500;

% Variables
var 0..x_max: x;
var 0..y_max: y;
var 0..(cost_x*x_max + cost_y*y_max): total_cost;

% Constraints
constraint x + y <= total_max;
constraint x - y >= min_excess;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;