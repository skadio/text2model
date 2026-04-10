% Parameters
int: total_max = 1000;
int: x_min = 200;
int: y_min = 300;
int: x_max = 500;
int: y_max = 700;
int: cost_x = 50;
int: cost_y = 70;

% Variables
var x_min..x_max: x;
var y_min..y_max: y;
var 0..(cost_x * x_max + cost_y * y_max): total_support;

% Constraints
constraint x + y <= total_max;
constraint total_support = cost_x * x + cost_y * y;

% Objective
solve minimize total_support;