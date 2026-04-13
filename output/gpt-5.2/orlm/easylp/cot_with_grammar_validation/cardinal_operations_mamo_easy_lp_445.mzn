% Parameters
int: total_limit = 2000;
int: min_diff_2x_minus_y = 500;      % 2*X - Y >= 500
int: max_diff_x_minus_2y = 1000;     % X - 2*Y <= 1000
int: max_x = 1500;
int: max_y = 1000;
int: cost_x = 5;
int: cost_y = 3;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= total_limit;
constraint 2*x - y >= min_diff_2x_minus_y;
constraint x - 2*y <= max_diff_x_minus_2y;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;