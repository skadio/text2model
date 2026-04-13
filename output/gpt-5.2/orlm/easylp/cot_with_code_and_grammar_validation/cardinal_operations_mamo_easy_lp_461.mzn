% Parameters
int: total_budget = 1000;
int: max_x = 700;
int: max_y = 500;

int: cost_x = 50;
int: cost_y = 30;

int: min_diff_xy = 200;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(cost_x * max_x + cost_y * max_y): total_cost;

% Constraints
constraint x + y <= total_budget;
constraint 3 * x - 2 * y >= 0;
constraint x - y >= min_diff_xy;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;