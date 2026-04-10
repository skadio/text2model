% Parameters
int: total_resources = 5000;
int: cost_x = 4;
int: cost_y = 3;
int: min_combo = 1000;

% Variables
var 0..total_resources: x;
var 0..total_resources: y;
var 0..(cost_x * total_resources + cost_y * total_resources): total_cost;

% Constraints
constraint x + y <= total_resources;
constraint x >= 2 * y;
constraint 2 * x + y >= min_combo;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;