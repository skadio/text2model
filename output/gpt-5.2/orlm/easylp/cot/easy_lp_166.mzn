% Parameters (with values embedded)
int: max_total_resources = 1000;
int: min_xy_combined = 200;
int: min_y2z_combined = 300;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: Z;

var 0..(costX*max_total_resources + costY*max_total_resources + costZ*max_total_resources): total_cost;

% Constraints
constraint X + Y + Z <= max_total_resources;

constraint X >= 2 * Y;
constraint X + Y >= min_xy_combined;

constraint Y + 2 * Z >= min_y2z_combined;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;