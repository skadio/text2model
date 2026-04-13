% Parameters
int: max_total = 100;
int: x_min = 30;
int: x_max = 70;
int: y_min = 20;
int: y_max = 80;
int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;
var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint X + Y <= max_total;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;