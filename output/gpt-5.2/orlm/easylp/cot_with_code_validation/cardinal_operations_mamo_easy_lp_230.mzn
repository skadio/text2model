% Parameters
int: max_total = 10000;
int: min_req = 5000;
int: max_diff = 3000;

int: cost_x = 10;
int: cost_y = 20;
int: cost_z = 30;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint 2*x + 3*y + z >= min_req;

constraint x - y + z <= max_diff;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;