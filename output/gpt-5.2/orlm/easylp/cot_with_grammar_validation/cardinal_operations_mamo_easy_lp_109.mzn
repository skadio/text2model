% Parameters
int: min_total_hours = 15;
int: max_weighted_hours = 40;
int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..max_weighted_hours: x;
var 0..max_weighted_hours: y;
var 0..(cost_x * max_weighted_hours + cost_y * max_weighted_hours): total_cost;

% Constraints
constraint x + y >= min_total_hours;
constraint 2 * x + y <= max_weighted_hours;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;