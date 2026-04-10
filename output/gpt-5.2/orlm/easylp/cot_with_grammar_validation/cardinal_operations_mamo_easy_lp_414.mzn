% Parameters
int: total_budget = 5000;
int: min_diff_2x_minus_y = 1000;
int: max_diff_x_minus_3y = 2000;

int: cost_x = 1000;
int: cost_y = 1500;

% Variables
var 0..total_budget: x;
var 0..total_budget: y;

% Constraints
constraint x + y <= total_budget;
constraint 2 * x - y >= min_diff_2x_minus_y;
constraint x - 3 * y <= max_diff_x_minus_3y;

% Objective
solve minimize cost_x * x + cost_y * y;