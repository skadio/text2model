% Parameters
int: max_total_units = 100;
int: req_xy = 50;
int: req_xz = 40;

int: cost_x = 5000;
int: cost_y = 4000;
int: cost_z = 6000;

% Variables
var 0..max_total_units: x;
var 0..max_total_units: y;
var 0..max_total_units: z;

var 0..(max_total_units * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= max_total_units;

constraint 2 * x + y >= req_xy;
constraint x + z >= req_xz;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;