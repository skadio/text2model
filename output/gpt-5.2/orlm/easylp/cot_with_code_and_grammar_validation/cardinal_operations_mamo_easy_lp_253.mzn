% Parameters
int: max_xy = 100;
int: max_xz = 80;
int: min_yz = 70;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 1;

% Variables
var 0..max(max_xy, max_xz): x;
var 0..max_xy: y;
var 0..max(max_xz, min_yz): z;

var 0..(cost_x*max(max_xy,max_xz) + cost_y*max_xy + cost_z*max(max_xz,min_yz)): total_cost;

% Constraints
constraint x + y <= max_xy;
constraint x + z <= max_xz;
constraint y + z >= min_yz;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;