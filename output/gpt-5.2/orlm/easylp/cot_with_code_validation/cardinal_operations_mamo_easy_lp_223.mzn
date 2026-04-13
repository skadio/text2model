% Parameters
int: total_resource = 100;
int: min_2x_plus_y = 50;
int: max_x_plus_z = 70;

int: cost_x = 50;
int: cost_y = 30;
int: cost_z = 20;

% Variables
var 0..total_resource: X;
var 0..total_resource: Y;
var 0..total_resource: Z;

var 0..(cost_x*total_resource + cost_y*total_resource + cost_z*total_resource): total_cost;

% Constraints
constraint X + Y + Z <= total_resource;
constraint 2 * X + Y >= min_2x_plus_y;
constraint X + Z <= max_x_plus_z;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;