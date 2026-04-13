% Parameters
int: max_total = 1000;
int: min_x = 400;
int: min_y = 300;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(max_total * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= max_total;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;