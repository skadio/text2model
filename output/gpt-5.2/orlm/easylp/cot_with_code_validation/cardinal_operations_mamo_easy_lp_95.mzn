% Parameters
int: max_total = 1000;
int: min_service = 500;
int: cost_x = 5;
int: cost_y = 7;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(cost_x * max_total + cost_y * max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint 2 * x + y >= min_service;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;