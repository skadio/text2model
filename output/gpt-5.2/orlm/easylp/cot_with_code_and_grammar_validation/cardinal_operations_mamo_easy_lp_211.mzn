% Parameters
int: total_resources = 100;
int: yz_max = 60;

int: costX = 5;
int: costY = 3;
int: costZ = 7;

% Variables
var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;

var 0..(costX*total_resources + costY*total_resources + costZ*total_resources): total_cost;

% Constraints
constraint X + Y + Z <= total_resources;
constraint Y + Z <= yz_max;

% X requires at least 10 more units than half of Y:
% 2*X >= Y + 20  (keeps everything integral)
constraint 2 * X >= Y + 20;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;