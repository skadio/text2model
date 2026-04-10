% Parameters
int: total_cap = 2000;
int: min_diff_2x_x_y = 500;      % 2*X - Y >= 500
int: max_diff_x_2y = 1000;       % X - 2*Y <= 1000
int: x_max = 1500;
int: y_max = 1000;
int: cost_x = 5;
int: cost_y = 3;

% Variables
var 0..x_max: x;
var 0..y_max: y;
var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint x + y <= total_cap;

constraint 2 * x - y >= min_diff_2x_x_y;
constraint x - 2 * y <= max_diff_x_2y;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;