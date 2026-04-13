% Parameters (with values embedded)
int: total_resources_limit = 5000;
int: min_service_level = 1000;
int: cost_X = 4;
int: cost_Y = 3;

% Variables
var 0..total_resources_limit: X;
var 0..total_resources_limit: Y;
var 0..(cost_X*total_resources_limit + cost_Y*total_resources_limit): total_cost;

% Constraints
constraint X + Y <= total_resources_limit;
constraint X >= 2 * Y;
constraint 2 * X + Y >= min_service_level;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;