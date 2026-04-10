% Parameters
int: total_resources = 100;
int: min_z_over_x = 10;
int: cost_x = 10;
int: cost_y = 20;
int: cost_z = 30;

% Variables
var 0..total_resources: x;
var 0..total_resources: y;
var 0..total_resources: z;
var 0..(cost_x*total_resources + cost_y*total_resources + cost_z*total_resources): total_cost;

% Constraints
constraint x + y + z <= total_resources;
constraint x >= 2 * y;
constraint z >= x + min_z_over_x;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;