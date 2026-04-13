% Parameters
int: min_total_time = 15;
int: max_weighted_time = 40;
int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..40: x;
var 0..40: y;

% Constraints
constraint x + y >= min_total_time;
constraint 2 * x + y <= max_weighted_time;

% Objective
solve minimize cost_x * x + cost_y * y;