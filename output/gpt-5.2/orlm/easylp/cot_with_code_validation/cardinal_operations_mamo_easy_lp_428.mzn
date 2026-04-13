% Parameters
int: capacity_total = 2000;
int: min_x = 800;
int: min_y = 500;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var min_x..capacity_total: x;
var min_y..capacity_total: y;
var 0..(cost_x*capacity_total + cost_y*capacity_total): total_cost;

% Constraints
constraint x + y <= capacity_total;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;