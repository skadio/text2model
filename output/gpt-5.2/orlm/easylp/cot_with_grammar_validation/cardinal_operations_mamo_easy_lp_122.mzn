% Parameters
int: max_total = 40;
int: min_x = 15;
int: min_y = 10;
int: max_x = 30;
int: max_y = 20;
int: cost_x = 10;
int: cost_y = 5;

% Variables
var min_x..max_x: x;
var min_y..max_y: y;
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= max_total;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;