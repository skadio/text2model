% Parameters
int: max_total = 5000;
int: min_xy = 2000;
int: max_yz = 2500;

int: cost_x = 50;
int: cost_y = 30;
int: cost_z = 20;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint x + y + z <= max_total;
constraint x + y >= min_xy;
constraint x = 2 * y;
constraint y + z <= max_yz;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;