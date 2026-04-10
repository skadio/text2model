% Parameters
int: max_total_weighted_hours = 40;          % 2*x + 3*y <= 40
int: min_total_weighted_hours = 30;          % 4*x + 1*y >= 30
int: cost_x = 8;
int: cost_y = 12;

% Variables
var 0..40: x;  % hours for group X (integer)
var 0..40: y;  % hours for group Y (integer)
var 0..(cost_x*40 + cost_y*40): total_cost;

% Constraints
constraint 2*x + 3*y <= max_total_weighted_hours;
constraint 4*x + y >= min_total_weighted_hours;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;