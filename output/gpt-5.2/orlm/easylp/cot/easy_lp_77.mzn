% Parameters (with values embedded)
int: max_effort = 120;
int: min_total_hours = 40;
int: coeff_x_effort = 2;
int: coeff_y_effort = 3;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var 0..max_effort: x;  % hours allocated to task X (integer, non-negative)
var 0..max_effort: y;  % hours allocated to task Y (integer, non-negative)
var 0..(cost_x*max_effort + cost_y*max_effort): total_cost;

% Constraints
constraint coeff_x_effort * x + coeff_y_effort * y <= max_effort;
constraint x + y >= min_total_hours;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;