% Parameters
int: req_min = 200;
int: cap_max = 300;

int: x_max = 100;
int: y_max = 80;

int: cost_x = 500;
int: cost_y = 600;

% Variables
var 0..x_max: X;
var 0..y_max: Y;

var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint 2 * X + 3 * Y >= req_min;
constraint 4 * X + 1 * Y <= cap_max;
constraint X >= Y;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;