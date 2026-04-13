% Parameters
int: max_units = 50;
int: min_roi = 100;

int: cost_x = 300;
int: cost_y = 200;
int: cost_z = 500;

int: roi_x = 5;
int: roi_y = 3;
int: roi_z = 10;

% Variables
var 0..max_units: x;
var 0..max_units: y;
var 0..max_units: z;

var 0..(max_units * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
constraint x + y + z <= max_units;
constraint roi_x * x + roi_y * y + roi_z * z >= min_roi;
constraint x - y >= 0;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;