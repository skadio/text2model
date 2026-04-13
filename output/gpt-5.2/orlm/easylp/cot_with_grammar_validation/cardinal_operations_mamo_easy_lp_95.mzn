% Parameters
int: total_resource_limit = 1000;
int: service_level_requirement = 500;
int: cost_x = 5;
int: cost_y = 7;

% Variables
var 0..total_resource_limit: x;
var 0..total_resource_limit: y;
var 0..(cost_x * total_resource_limit + cost_y * total_resource_limit): total_cost;

% Constraints
constraint x + y <= total_resource_limit;
constraint 2 * x + y >= service_level_requirement;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;