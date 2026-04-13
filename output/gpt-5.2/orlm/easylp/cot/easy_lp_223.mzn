% Parameters (with values embedded)
int: total_resources = 100;
int: min_requirement = 50;      % for 2*X + Y
int: max_xz = 70;               % for X + Z

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;

var 0..(costX*total_resources + costY*total_resources + costZ*total_resources): total_cost;

% Constraints
constraint X + Y + Z <= total_resources;
constraint 2*X + Y >= min_requirement;
constraint X + Z <= max_xz;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;