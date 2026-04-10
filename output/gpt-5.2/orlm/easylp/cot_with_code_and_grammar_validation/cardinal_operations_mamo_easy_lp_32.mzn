% Parameters
int: max_total = 1000;
int: min_x = 400;
int: min_y = 300;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var min_x..max_total: x;
var min_y..max_total: y;
var 0..(cost_x * max_total + cost_y * max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;