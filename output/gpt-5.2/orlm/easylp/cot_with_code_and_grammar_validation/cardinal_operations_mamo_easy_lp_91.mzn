% Parameters
int: total_limit = 1000;
int: min_requirement = 800;
int: balance_limit = 200;
int: cost_x = 4;
int: cost_y = 3;

% Variables
var 0..total_limit: x;
var 0..total_limit: y;
var 0..(cost_x*total_limit + cost_y*total_limit): total_cost;

% Constraints
constraint x + y <= total_limit;
constraint 2*x + y >= min_requirement;
constraint abs(x - y) <= balance_limit;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;