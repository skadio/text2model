% Parameters
int: max_total_weighted_hours = 40;   % 2*X + 3*Y <= 40
int: min_total_weighted_hours = 30;   % 4*X + 1*Y >= 30
int: cost_x = 8;
int: cost_y = 12;

% Variables
var 0..100: x;  % hours for group X (integer, non-negative)
var 0..100: y;  % hours for group Y (integer, non-negative)
var 0..10000: total_cost;

% Constraints
constraint 2*x + 3*y <= max_total_weighted_hours;
constraint 4*x + y >= min_total_weighted_hours;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;