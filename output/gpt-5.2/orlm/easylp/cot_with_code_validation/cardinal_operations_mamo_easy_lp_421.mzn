% Parameters
int: total_max = 5000;
int: x_min = 1000;
int: y_min = 1500;
int: cost_x = 100;
int: cost_y = 75;

% Variables
var x_min..total_max: X;
var y_min..total_max: Y;
var int: total_cost;

% Constraints
constraint X + Y <= total_max;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;