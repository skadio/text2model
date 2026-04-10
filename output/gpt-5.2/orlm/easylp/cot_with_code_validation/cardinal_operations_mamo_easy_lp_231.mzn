% Parameters
int: land_max = 1000;

int: min_x = 200;
int: min_y = 150;
int: min_z = 100;

int: cost_x = 10;
int: cost_y = 20;
int: cost_z = 30;

% Variables
var min_x..land_max: x;
var min_y..land_max: y;
var min_z..land_max: z;

var 0..(land_max * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= land_max;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;