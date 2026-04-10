% Parameters
int: total_max = 5000;
int: x_min = 1000;
int: y_min = 1500;
int: cost_x = 100;
int: cost_y = 75;

% Variables
var 0..total_max: X;
var 0..total_max: Y;
var 0..(cost_x*total_max + cost_y*total_max): total_cost;

% Constraints
constraint X + Y <= total_max;

constraint X >= x_min;
constraint Y >= y_min;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;