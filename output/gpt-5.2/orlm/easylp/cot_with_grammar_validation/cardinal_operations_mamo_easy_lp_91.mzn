% Parameters
int: total_cap = 1000;
int: min_weighted = 800;
int: max_diff = 200;
int: cost_x = 4;
int: cost_y = 3;

% Variables
var 0..total_cap: x;
var 0..total_cap: y;
var 0..(cost_x*total_cap + cost_y*total_cap): total_cost;

% Constraints
constraint x + y <= total_cap;
constraint 2*x + y >= min_weighted;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;