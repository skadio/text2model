% Parameters
int: max_total_resources = 10000;
int: min_weighted_sum = 6000;
int: max_diff = 2000;

int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var 0..max_total_resources: x;
var 0..max_total_resources: y;
var 0..(cost_x*max_total_resources + cost_y*max_total_resources): total_cost;

% Constraints
constraint x + y <= max_total_resources;
constraint 2*x + y >= min_weighted_sum;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;