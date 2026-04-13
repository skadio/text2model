% Parameters (with values embedded)
int: total_resource_limit = 1000;

% Unit costs
int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Strategic/operational bounds (not explicitly given; use natural nonnegative bounds)
int: minX = 0; int: maxX = total_resource_limit;
int: minY = 0; int: maxY = total_resource_limit;
int: minZ = 0; int: maxZ = total_resource_limit;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(costX*total_resource_limit + costY*total_resource_limit + costZ*total_resource_limit): total_cost;

% Constraints
constraint X + Y + Z <= total_resource_limit;
constraint X >= 2 * Y + 100;
constraint abs(Y - Z) <= 50;
constraint X + Z >= 300;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;