% Parameters
int: min_total = 20;
int: max_weighted = 40;
int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..max_weighted: x;
var 0..max_weighted: y;
var 0..(cost_x*max_weighted + cost_y*max_weighted): total_cost;

% Constraints
constraint x + y >= min_total;
constraint 2*x + y <= max_weighted;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;