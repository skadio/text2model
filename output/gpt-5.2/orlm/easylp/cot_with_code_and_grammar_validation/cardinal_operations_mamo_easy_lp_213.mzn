% Parameters
int: total_units = 100;
int: min_x = 10;
int: min_y = 20;
int: min_z = 15;

int: cost_x = 30;
int: cost_y = 20;
int: cost_z = 50;

% Variables
var min_x..total_units: x;
var min_y..total_units: y;
var min_z..total_units: z;

var 0..(total_units * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= total_units;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;