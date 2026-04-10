% Parameters
int: max_total_resources = 1000;
int: coef_X = 2;
int: coef_Y = 3;
int: min_diff_XY = 100;

int: cost_X = 5;
int: cost_Y = 7;

% Variables
var 0..max_total_resources: x;
var 0..max_total_resources: y;
var 0..(cost_X*max_total_resources + cost_Y*max_total_resources): total_cost;

% Constraints
constraint coef_X * x + coef_Y * y <= max_total_resources;
constraint x >= y + min_diff_XY;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;