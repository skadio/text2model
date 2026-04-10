% Parameters
int: max_total = 1000;
int: min_xy = 200;
int: min_yz = 300;

int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 20;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;
var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint x >= 2 * y;
constraint x + y >= min_xy;

constraint y + 2 * z >= min_yz;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;