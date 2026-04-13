% Parameters
int: total_space = 2000;
int: demand_min = 500;
int: balance_limit = 1000;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..total_space: x;
var 0..total_space: y;
var 0..(cost_x*total_space + cost_y*total_space): total_cost;

% Constraints
constraint x + y <= total_space;
constraint 2*x + y >= demand_min;
constraint abs(x - 2*y) <= balance_limit;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;