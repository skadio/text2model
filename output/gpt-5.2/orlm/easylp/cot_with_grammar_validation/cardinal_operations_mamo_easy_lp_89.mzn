% Parameters
int: min_total_hours = 10;
int: max_weighted_hours = 24;
int: cost_X = 8;
int: cost_Y = 5;

% Variables
var 0..min_total_hours: X;
var 0..min_total_hours: Y;
var 0..(cost_X * min_total_hours + cost_Y * min_total_hours): total_cost;

% Constraints
constraint X + Y >= min_total_hours;
constraint 2 * X + 3 * Y <= max_weighted_hours;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;