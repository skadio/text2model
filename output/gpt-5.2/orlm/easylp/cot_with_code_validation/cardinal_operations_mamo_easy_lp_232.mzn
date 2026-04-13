% Parameters
int: max_total_resource = 1000;
int: min_xy_yield = 3000;
int: min_z_minus_3y = -500;

int: yield_x = 4;
int: yield_y = 5;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 1;

% Variables
var 0..max_total_resource: X;
var 0..max_total_resource: Y;
var 0..max_total_resource: Z;

var 0..(cost_x*max_total_resource + cost_y*max_total_resource + cost_z*max_total_resource): total_cost;

% Constraints
constraint X + Y + Z <= max_total_resource;

constraint yield_x * X + yield_y * Y >= min_xy_yield;

constraint Z - 3 * Y >= min_z_minus_3y;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;