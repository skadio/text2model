% Parameters (with values embedded)
int: max_total_resources = 1000;

int: min_2X_plus_Y = 500;
int: max_X_plus_3Z = 800;

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
constraint 2*X + Y >= min_2X_plus_Y;
constraint X + 3*Z <= max_X_plus_3Z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;