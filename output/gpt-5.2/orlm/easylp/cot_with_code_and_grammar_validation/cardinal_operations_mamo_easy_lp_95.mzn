% Parameters
int: total_limit = 1000;
int: demand_min = 500;
int: cost_x = 5;
int: cost_y = 7;

% Variables
var 0..total_limit: x;
var 0..total_limit: y;
var 0..(cost_x*total_limit + cost_y*total_limit): total_cost;

% Constraints
constraint x + y <= total_limit;
constraint 2*x + y >= demand_min;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;