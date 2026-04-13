% Parameters (with values embedded)
int: total_resource_limit = 200;
int: min_combined_requirement = 100;
int: max_diff = 50;

int: x_max = 150;
int: y_max = 100;

int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var 0..x_max: x; % resources for project X (integer units)
var 0..y_max: y; % resources for project Y (integer units)

var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint x + y <= total_resource_limit;
constraint 2 * x + y >= min_combined_requirement;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;