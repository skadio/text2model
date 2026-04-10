% Parameters
int: total_resources = 100;
int: min_2x_plus_y = 50;
int: max_x_plus_z = 70;

int: cost_x = 50;
int: cost_y = 30;
int: cost_z = 20;

% Variables
var 0..total_resources: x;
var 0..total_resources: y;
var 0..total_resources: z;

var 0..(cost_x*total_resources + cost_y*total_resources + cost_z*total_resources): total_cost;

% Constraints
constraint x + y + z <= total_resources;
constraint 2*x + y >= min_2x_plus_y;
constraint x + z <= max_x_plus_z;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;