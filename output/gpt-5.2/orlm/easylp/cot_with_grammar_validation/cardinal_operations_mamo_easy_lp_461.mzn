% Parameters
int: total_budget = 1000;
int: cost_x = 50;
int: cost_y = 30;
int: max_x = 700;
int: max_y = 500;
int: min_diff_xy = 200;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..(cost_x * max_x + cost_y * max_y): total_cost;

% Constraints
constraint X + Y <= total_budget;
constraint 3 * X - 2 * Y >= 0;
constraint X - Y >= min_diff_xy;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;