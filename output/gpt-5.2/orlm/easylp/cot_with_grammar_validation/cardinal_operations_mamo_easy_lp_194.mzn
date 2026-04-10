% Parameters
int: max_total = 1000;
int: min_2x_plus_y = 200;
int: max_x_plus_z = 300;

int: cost_x = 5;
int: cost_y = 4;
int: cost_z = 3;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint x + y + z <= max_total;
constraint 2*x + y >= min_2x_plus_y;
constraint x + z <= max_x_plus_z;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;