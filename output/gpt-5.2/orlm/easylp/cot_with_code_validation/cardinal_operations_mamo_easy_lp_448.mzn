% Parameters
int: cost_x = 50;
int: cost_y = 100;
int: max_total = 2000;
int: min_diff = 500;
int: min_x = 750;

% Variables
var 0..max_total: x;
var 0..max_total: y;

% Constraints
constraint x + y <= max_total;
constraint x - 2 * y >= min_diff;
constraint x >= min_x;

% Objective
solve minimize cost_x * x + cost_y * y;