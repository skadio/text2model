% Parameters
int: max_total = 100;
int: min_x = 20;
int: min_y = 30;
int: min_z = 10;

int: cost_x = 5000;
int: cost_y = 4000;
int: cost_z = 6000;

% Variables
var min_x..max_total: x;
var min_y..max_total: y;
var min_z..max_total: z;

var 0..(max_total * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;