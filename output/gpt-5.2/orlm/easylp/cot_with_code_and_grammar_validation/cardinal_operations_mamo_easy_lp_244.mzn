% Parameters
int: total_capacity = 100;
int: req_xy = 50;
int: diff_xz_max = 20;

int: cost_x = 5000;
int: cost_y = 4000;
int: cost_z = 3000;

% Variables
var 0..total_capacity: x;
var 0..total_capacity: y;
var 0..total_capacity: z;

var 0..(cost_x*total_capacity + cost_y*total_capacity + cost_z*total_capacity): total_cost;

% Constraints
constraint x + y + z <= total_capacity;

constraint 2*x + 3*y >= req_xy;

constraint abs(x - z) <= diff_xz_max;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;