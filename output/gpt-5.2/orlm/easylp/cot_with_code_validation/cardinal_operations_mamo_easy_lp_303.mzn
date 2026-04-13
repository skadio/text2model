% Parameters
int: rx = 2;
int: ry = 3;
int: rz = 1;

int: min_xy = 10;
int: max_2x_plus_z = 15;
int: min_y_minus_z = 5;

% Variables
var 0..15: x;
var 0..15: y;
var 0..15: z;

var 0..(rx*15 + ry*15 + rz*15): total_resource;

% Constraints
constraint x + y >= min_xy;
constraint 2*x + z <= max_2x_plus_z;
constraint y - z >= min_y_minus_z;

constraint total_resource = rx*x + ry*y + rz*z;

% Objective
solve minimize total_resource;