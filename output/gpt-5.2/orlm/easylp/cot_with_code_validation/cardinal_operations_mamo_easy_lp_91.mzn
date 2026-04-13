% Parameters
int: total_limit = 1000;
int: min_weighted = 800;
int: max_diff = 200;
int: cost_x = 4;
int: cost_y = 3;

% Variables
var 0..total_limit: x;
var 0..total_limit: y;
var 0..(cost_x*total_limit + cost_y*total_limit): total_cost;

% Constraints
constraint x + y <= total_limit;
constraint 2*x + y >= min_weighted;
constraint abs(x - y) <= max_diff;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;