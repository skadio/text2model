% Parameters (with values embedded)
int: max_total_resources = 5000;
int: min_XY_total = 2000;
int: max_YZ_total = 2500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: Z;

var 0..(costX*max_total_resources + costY*max_total_resources + costZ*max_total_resources): total_cost;

% Constraints
constraint X + Y + Z <= max_total_resources;
constraint X + Y >= min_XY_total;
constraint 2 * X = Y;
constraint Y + Z <= max_YZ_total;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;