% Parameters
int: max_total = 1000;
int: min_x_minus_y = 10;
int: max_z_minus_y = 20;

int: cost_x = 5;
int: cost_y = 2;
int: cost_z = 3;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint x + y + z <= max_total;
constraint x - y >= min_x_minus_y;
constraint z - y <= max_z_minus_y;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;