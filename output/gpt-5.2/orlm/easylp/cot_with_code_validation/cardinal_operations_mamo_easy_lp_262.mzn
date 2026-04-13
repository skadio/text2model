% Parameters
int: max_total_hires = 100;
int: min_x = 20;
int: min_y = 30;
int: min_z = 10;

int: cost_x = 50000;
int: cost_y = 60000;
int: cost_z = 70000;

% Variables
var min_x..max_total_hires: x;
var min_y..max_total_hires: y;
var min_z..max_total_hires: z;

var 0..(max_total_hires * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= max_total_hires;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;