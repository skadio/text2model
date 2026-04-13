% Parameters (with values embedded)
int: total_resource = 100;
int: minX = 10;
int: minY = 20;
int: minZ = 15;

int: costX = 30;
int: costY = 20;
int: costZ = 50;

% Variables
var minX..total_resource: X;
var minY..total_resource: Y;
var minZ..total_resource: Z;

var 0..(costX*total_resource + costY*total_resource + costZ*total_resource): total_cost;

% Constraints
constraint X + Y + Z <= total_resource;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;