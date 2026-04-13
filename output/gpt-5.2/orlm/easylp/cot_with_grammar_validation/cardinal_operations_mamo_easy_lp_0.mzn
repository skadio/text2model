% Parameters
int: budget = 1000;
int: min_excess = 200;
int: cost_x = 50;
int: cost_y = 30;
int: max_x = 700;
int: max_y = 500;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= budget;
constraint x - y >= min_excess;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;