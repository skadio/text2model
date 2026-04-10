% Parameters (with values embedded)
int: min_total_time = 15;
int: max_weighted_time = 40;  % 2*x + y <= 40
int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..40: x;  % hours on exercise X (integer, bounded by constraints)
var 0..40: y;  % hours on exercise Y (integer, bounded by constraints)
var 0..2000: total_cost;

% Constraints
constraint x + y >= min_total_time;
constraint 2*x + y <= max_weighted_time;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;