% Parameters
int: min_total_hours = 10;
int: max_weighted_hours = 24;
int: cost_x = 8;
int: cost_y = 5;
int: weight_x = 2;
int: weight_y = 3;

% Variables
var 0..max_weighted_hours: X;
var 0..max_weighted_hours: Y;
var 0..(cost_x*max_weighted_hours + cost_y*max_weighted_hours): total_cost;

% Constraints
constraint X + Y >= min_total_hours;
constraint weight_x * X + weight_y * Y <= max_weighted_hours;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;