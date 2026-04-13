% Parameters
int: max_hours = 24;
int: min_x = 4;
int: min_y = 6;
int: cost_x = 8;
int: cost_y = 10;

% Variables
var 0..max_hours: x;
var 0..max_hours: y;
var 0..(max_hours * (cost_x + cost_y)): total_cost;

% Constraints
constraint x + y <= max_hours;
constraint x >= min_x;
constraint y >= min_y;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;